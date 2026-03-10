import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../res/app_url/app_url.dart';
import '../../../../res/components/api_service.dart';
import '../../../../widgets/show_custom_snackbar.dart';
import '../../auth/providers/auth_controller.dart';
import 'web_socket_service.dart';

class ChatsController extends GetxController {
  final ApiService apiService = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AuthController authController = Get.find<AuthController>();
  WebSocketService? _wsService;

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString message = ''.obs;
  final RxBool isTyping = false.obs;
  final TextEditingController textController = TextEditingController();
  final RxBool isMessageLoading = false.obs;
  final RxBool isRoomLoading = false.obs;
  final RxBool isRoomsLoading = false.obs;
  final RxString chatError = ''.obs;
  final RxString roomsError = ''.obs;
  final RxnInt roomId = RxnInt();
  final rooms = <Map<String, dynamic>>[].obs;
  // final ImagePicker _picker = ImagePicker();
  final RxBool isFileUploading = false.obs;
  final FocusNode inputFocusNode = FocusNode();
  final RxBool isRecipientTyping = false.obs;
  final RxBool isOnline = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final RxBool isLoadingMoreMessages = false.obs;
  final RxBool isSending = false.obs;
  final RxBool hasMoreMessages = true.obs;
  final RxInt currentPage = 1.obs;
  final Rxn<XFile> pickedImage = Rxn<XFile>();
  final RxString setSelectedTab = 'ChatHistory'.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedTab = 'ChatHistory'.obs;
  final RxList<Map<String, String>> chats = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> invitations = <Map<String, String>>[].obs;
  final RxList<String> names = <String>[].obs;
  final RxList<String> images = <String>[].obs;
  final Duration cacheDuration = const Duration(minutes: 2);
  final RxBool isUserBlocked = false.obs;
  final RxMap<String, String> chatRooms =
      <String, String>{}.obs; // userId -> roomId
  final RxBool isFetchingChats = false.obs;
  final RxBool isRecipientOnline = false.obs;
  late bool _noInvitationsFound = false;
  final Map<String, String> userAvatarCache = {};

  RxBool isuserblocked = false.obs;
  ScrollController? scrollController;
  int? currentRoomId;
  String makeAbsolutePhoto(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final host = Api.getMessagesUrl;
    final p = path.startsWith('/') ? path : '/$path';
    final normalized = p.contains('/media/') ? p : '/media$p';
    return '$host$normalized';
  }

  Map<String, dynamic>? firstParticipant(Map<String, dynamic> room) {
    final parts = room['participants'];
    if (parts is List && parts.isNotEmpty) {
      final p = parts.first;
      return (p is Map<String, dynamic>) ? p : null;
    }
    return null;
  }

  String roomTitle(Map<String, dynamic> room) {
    final p = firstParticipant(room);
    if (p == null) return 'Unknown';
    return (p['name'] as String?)?.trim().isNotEmpty == true
        ? p['name']
        : ((p['username'] as String?)?.trim().isNotEmpty == true
        ? p['username']
        : 'User #${p['id']}');
  }

  String? roomAvatar(Map<String, dynamic> room) {
    final p = firstParticipant(room);
    return p?['profile_photo'] as String?;
  }

  String lastMessageText(Map<String, dynamic> room) {
    final lm = room['last_message'];
    return (lm is String && lm.trim().isNotEmpty) ? lm : 'No messages yet';
  }

  String? currentUserId;
  String? currentRecipientId;
  String? accessToken;
  Timer? _typingTimer;

  DateTime? lastChatsFetch;
  DateTime? lastInvitationsFetch;
  bool get isChatsCacheExpired {
    if (lastChatsFetch == null) return true;
    return DateTime.now().difference(lastChatsFetch!) > cacheDuration;
  }

  bool get isInvitationsCacheExpired {
    if (lastInvitationsFetch == null) return true;
    return DateTime.now().difference(lastInvitationsFetch!) > cacheDuration;
  }

  bool get noInvitationsFound => _noInvitationsFound;
  Timer? _refetchTimer;
  String? myAvatarUrl;

  void onTextChanged(String value) {
    message.value = value;

    // Handle typing indicator - only send if WebSocket is connected
    if (_wsService != null && _wsService!.isConnected) {
      // Use a debounced approach to avoid too many typing events
      _typingTimer?.cancel();

      if (value.isNotEmpty && !isTyping.value) {
        try {
          _wsService!.sendTypingStatus(true);
          isTyping.value = true;
        } catch (e) {
          debugPrint('Failed to send typing status: $e');
          // Continue without typing indicator if not supported
        }
      }

      // Always set a timer to stop typing indicator
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (isTyping.value) {
          try {
            _wsService!.sendTypingStatus(false);
          } catch (e) {
            debugPrint('Failed to stop typing status: $e');
          }
          isTyping.value = false;
        }
      });
    }

    // Auto-scroll when typing
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });
  }

  void _handleWebSocketMessage(Map<String, dynamic> data, int roomId) {
    try {
      debugPrint('Handling WebSocket message: $data');

      // Skip error messages
      if (data['type'] == 'error') {
        debugPrint('Server error ignored: ${data['message']}');
        return;
      }

      // Handle different message types
      if (data.containsKey('typing') || data['action'] == 'typing') {
        // Handle typing indicator
        final senderId =
            data['sender_id']?.toString() ?? data['sender']?.toString() ?? '';
        final currentUserId = authController.id.value;

        if (senderId != currentUserId && senderId.isNotEmpty) {
          isRecipientTyping.value = data['typing'] ?? false;
        }
        return;
      }

      // Handle online status
      if (data.containsKey('online_status') ||
          data['action'] == 'online_status') {
        final userId =
            data['user_id']?.toString() ?? data['sender_id']?.toString() ?? '';
        final currentUserId = authController.id.value;

        if (userId != currentUserId && userId.isNotEmpty) {
          isRecipientOnline.value =
              data['online_status'] ?? data['online'] ?? false;
        }
        return;
      }

      // Handle read status updates
      if (data.containsKey('message_read') ||
          data['action'] == 'read_receipt') {
        final messageId = data['message_id'];
        if (messageId != null) {
          // Update the specific message's read status
          final messageIndex = messages.indexWhere(
                (msg) => msg['id'].toString() == messageId.toString(),
          );
          if (messageIndex != -1) {
            final updatedMessage = Map<String, dynamic>.from(
              messages[messageIndex],
            );
            updatedMessage['is_read'] = true;
            messages[messageIndex] = updatedMessage;
          }
        }
        return;
      }

      // Handle regular messages (text, image, file)
      if (data.containsKey('message') ||
          data.containsKey('content') ||
          data.containsKey('file')) {
        // Extract sender information properly
        Map<String, dynamic> senderInfo = {};
        if (data['sender'] is Map<String, dynamic>) {
          senderInfo = data['sender'];
          debugPrint('Sender info: $senderInfo');
        } else if (data['sender_id'] != null) {
          senderInfo = {
            'id': data['sender_id'],
            'username': data['sender_username'] ?? '',
            'name': data['sender_name'] ?? '',
          };
          debugPrint('Sender ID info: $senderInfo');
        } else {
          debugPrint('Warning: No sender information found in message');
          return;
        }

        final newMessage = {
          'id': data['id'] ?? DateTime.now().millisecondsSinceEpoch,
          'room': roomId,
          'sender': senderInfo,
          'content': data['message'] ?? data['content'] ?? '',
          'file': data['file'],
          'file_name': data['file_name'],
          'file_type': data['file_type'],
          'image': data['image_url'],
          'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
          'is_read': data['is_read'] ?? false,
        };

        debugPrint('Adding new message: $newMessage');

        // Add to messages list
        messages.add(newMessage);

        // Scroll to bottom when new message arrives
        Future.delayed(
          const Duration(milliseconds: 100),
              () => scrollToBottom(),
        );

        // Mark message as read if it's from the other user and chat is visible
        final senderId = senderInfo['id']?.toString() ?? '';
        final currentUserId = authController.id.value;

        if (senderId != currentUserId && senderId.isNotEmpty) {
          _markMessageAsRead(newMessage['id']);
        }
      }
    } catch (e) {
      debugPrint('Error handling WebSocket message: $e');
    }
  }

  Future<void> sendImage({
    ImageSource source = ImageSource.gallery,
    required File file,
  }) async {
    if (_wsService == null || !_wsService!.isConnected) {
      showCustomSnackBar(
        title: 'Error',
        message: 'Not connected to chat',
        isSuccess: false,
      );
      return;
    }

    try {
      isFileUploading(true);
      isSending.value = true;

      final Uint8List bytes = await file.readAsBytes();
      final fileName = file.path.split('/').last;

      print('fileName_____ $fileName');
      scrollToBottom();

      _wsService!.sendImage(
        bytes,
        fileName: fileName,
        caption: message.value.trim().isNotEmpty ? message.value.trim() : null,
      );

      // Clear caption if any
      if (message.value.trim().isNotEmpty) {
        message.value = '';
        textController.clear();
      }

      debugPrint('Image sent: $fileName');
    } catch (e) {
      debugPrint('Error sending image: $e');
      showCustomSnackBar(
        title: 'Error',
        message: 'Failed to send image',
        isSuccess: false,
      );
    } finally {
      isFileUploading(false);
      isSending.value = false;
    }
  }

  Future<void> sendFile(File file) async {
    if (_wsService == null || !_wsService!.isConnected) {
      showCustomSnackBar(
        title: 'Error',
        message: 'Not connected to chat',
        isSuccess: false,
      );
      return;
    }

    try {
      isFileUploading(true);
      isSending.value = true;

      final Uint8List bytes = await file.readAsBytes();
      final fileName = file.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();

      String fileType = 'file';
      if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
        fileType = 'image';
      } else if (['mp4', 'mov', 'avi', 'mkv'].contains(fileExtension)) {
        fileType = 'video';
      } else if (['mp3', 'wav', 'm4a', 'aac'].contains(fileExtension)) {
        fileType = 'audio';
      } else if (['pdf', 'doc', 'docx', 'txt'].contains(fileExtension)) {
        fileType = 'document';
      }


      scrollToBottom();

      _wsService!.sendFile(
        bytes,
        fileName: fileName,
        fileType: fileType,
        caption: message.value.trim().isNotEmpty ? message.value.trim() : null,
      );

      // Clear caption if any
      if (message.value.trim().isNotEmpty) {
        message.value = '';
        textController.clear();
      }

      debugPrint('File sent: $fileName');
    } catch (e) {
      debugPrint('Error sending file: $e');
      showCustomSnackBar(
        title: 'Error',
        message: 'Failed to send file',
        isSuccess: false,
      );
    } finally {
      isFileUploading(false);
      isSending.value = false;
    }
  }

  void sendMessage() {
    if (message.value.trim().isEmpty ||
        _wsService == null ||
        !_wsService!.isConnected) {
      debugPrint('Cannot send message - no content or not connected');
      return;
    }

    try {
      isSending.value = true;


      scrollToBottom();

      _wsService!.sendMessage(message.value.trim());

      // Clear message field
      message.value = '';
      textController.clear();

      // Stop typing indicator
      if (isTyping.value) {
        try {
          _wsService!.sendTypingStatus(false);
        } catch (e) {
          debugPrint('Failed to stop typing indicator: $e');
        }
        isTyping.value = false;
      }

      debugPrint('Message sent successfully');
    } catch (e) {
      debugPrint('Error sending message: $e');
      showCustomSnackBar(
        title: 'Error',
        message: 'Failed to send message',
        isSuccess: false,
      );
    } finally {
      isSending.value = false;
    }
  }

  void _sendTypingStatusSafely(bool typing) {
    try {
      if (_wsService != null && _wsService!.isConnected) {
        _wsService!.sendTypingStatus(typing);
      }
    } catch (e) {
      debugPrint('Failed to send typing status: $e');
      // Don't show error to user, just log it
    }
  }

  void sendTypingStatus(bool typing) {
    if (_wsService != null && _wsService!.isConnected) {
      try {
        _wsService!.sendTypingStatus(typing);
      } catch (e) {
        debugPrint('Typing status error: $e');
        // Fallback: try different action names that servers commonly expect
        _tryAlternativeTypingActions(typing);
      }
    }
  }

  void _tryAlternativeTypingActions(bool typing) {
    if (_wsService == null || !_wsService!.isConnected) return;

    // Try common alternative action names
    final alternatives = ['typing', 'user_typing', 'typing_indicator'];

    for (String action in alternatives) {
      try {
        _wsService!.sendCustomAction(action, {'typing': typing});
        debugPrint('Successfully sent typing status with action: $action');
        break; // If successful, stop trying alternatives
      } catch (e) {
        debugPrint('Failed with action $action: $e');
        continue; // Try next alternative
      }
    }
  }

  void updateLists() {
    if (selectedTab.value == 'ChatHistory') {
      names.assignAll(chats.map((chat) => chat['name']!).toList());
      images.assignAll(chats.map((chat) => chat['image']!).toList());
    } else {
      names.assignAll(invitations.map((invite) => invite['name']!).toList());
      images.assignAll(invitations.map((invite) => invite['image']!).toList());
    }
  }

  void handleTypingEvent(String roomId, {required bool typing}) {
    if (roomId == currentRoomId.toString()) {
      isRecipientTyping.value = typing;
    }
  }

  void handleOnlineStatusEvent(String userId, {required bool online}) {
    if (currentRecipientId == userId) {
      isRecipientOnline.value = online;
    }
  }

  void closeChat() {
    cleanupChat();
    _cancelPeriodicRefetch();
  }

  void _cancelPeriodicRefetch() {
    _refetchTimer?.cancel();
    _refetchTimer = null;
  }

  void _showErrorSnackbar(String errorMessage) {
    showCustomSnackBar(title: 'Error', message: errorMessage, isSuccess: false);
  }

  void clearInput() {
    textController.clear();
    pickedImage.value = null;
  }

  void setScrollController(ScrollController controller) {
    scrollController = controller;
  }

  void scrollToBottom({bool animate = true}) {
    if (scrollController?.hasClients == true) {
      if (animate) {
        scrollController!.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
      }
    }
  }

  void scrollToBottom1({bool animate = true}) {
    scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
  }

  void _markMessageAsRead(dynamic messageId) {
    if (_wsService != null && _wsService!.isConnected) {
      try {
        final data = jsonEncode({
          'action': 'mark_read',
          'message_id': messageId,
        });
        // Send read receipt through WebSocket
        // You may need to add this method to your WebSocketService
      } catch (e) {
        debugPrint('Error marking message as read: $e');
      }
    }
  }

  void cleanupChat() {
    _wsService?.disconnect();
    _wsService = null;
    currentRoomId = null;
    messages.clear();
    textController.clear();
    message.value = '';
    isTyping.value = false;
    isRecipientTyping.value = false;
    isRecipientOnline.value = false;
    scrollController = null;
    _typingTimer?.cancel();
  }

  @override
  void onClose() {
    textController.dispose();
    _wsService?.disconnect();
    _typingTimer?.cancel();
    scrollController = null;
    super.onClose();
  }

  void _connectWebSocket(int roomId) {
    final token = authController.accessToken.value;

    _wsService = WebSocketService(token);

    _wsService!.connect(
      roomId,
      onMessage: (data) {
        _handleWebSocketMessage(data, roomId);
      },
      onError: (error) {
        debugPrint("WebSocket Error: $error");
        showCustomSnackBar(
          title: 'Connection Error',
          message: 'Lost connection to chat',
          isSuccess: false,
        );
      },
      onDone: () {
        debugPrint("WebSocket connection closed");
      },
    );
  }

  Future<void> fetchChatsIfNeeded({bool force = false}) async {
    if (force || isChatsCacheExpired) {
      await fetchChats();
    }
  }

  Future<void> fetchInvitationsIfNeeded({bool force = false}) async {
    if (_noInvitationsFound && !force) return;
    if (force || isInvitationsCacheExpired) {
      await fetchInvitations();
    }
  }

  Future<void> initializeChat(int roomId) async {
    currentRoomId = roomId;
    messages.clear(); // Clear previous messages

    // Disconnect existing WebSocket if any
    _wsService?.disconnect();

    // Fetch existing messages
    await fetchMessages(roomId);

    // Connect to WebSocket using service
    _connectWebSocket(roomId);

    // Scroll to bottom after loading messages
    Future.delayed(const Duration(milliseconds: 500), () => scrollToBottom());
  }

  // Future<void> sendImage({
  //   ImageSource source = ImageSource.gallery,
  //   required File file,
  // }) async {
  //   if (_wsService == null || !_wsService!.isConnected) {
  //     showCustomSnackBar(
  //       title: 'Error',
  //       message: 'Not connected to chat',
  //       isSuccess: false,
  //     );
  //     return;
  //   }
  //
  //   try {
  //     isFileUploading(true);
  //     isSending.value = true;
  //
  //     final Uint8List bytes = await file.readAsBytes();
  //     final fileName = file.path.split('/').last;
  //
  //     _wsService!.sendImage(
  //       bytes,
  //       fileName: fileName,
  //       caption: message.value.trim().isNotEmpty ? message.value.trim() : null,
  //     );
  //
  //     // Clear caption if any
  //     if (message.value.trim().isNotEmpty) {
  //       message.value = '';
  //       textController.clear();
  //     }
  //
  //     debugPrint('Image sent: $fileName');
  //   } catch (e) {
  //     debugPrint('Error sending image: $e');
  //     showCustomSnackBar(
  //       title: 'Error',
  //       message: 'Failed to send image',
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isFileUploading(false);
  //     isSending.value = false;
  //   }
  // }
  // Future<void> sendFile(File file) async {
  //   if (_wsService == null || !_wsService!.isConnected) {
  //     showCustomSnackBar(
  //       title: 'Error',
  //       message: 'Not connected to chat',
  //       isSuccess: false,
  //     );
  //     return;
  //   }
  //
  //   try {
  //     isFileUploading(true);
  //     isSending.value = true;
  //
  //     final Uint8List bytes = await file.readAsBytes();
  //     final fileName = file.path.split('/').last;
  //     final fileExtension = fileName.split('.').last.toLowerCase();
  //
  //     String fileType = 'file';
  //     if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
  //       fileType = 'image';
  //     } else if (['mp4', 'mov', 'avi', 'mkv'].contains(fileExtension)) {
  //       fileType = 'video';
  //     } else if (['mp3', 'wav', 'm4a', 'aac'].contains(fileExtension)) {
  //       fileType = 'audio';
  //     } else if (['pdf', 'doc', 'docx', 'txt'].contains(fileExtension)) {
  //       fileType = 'document';
  //     }
  //
  //     _wsService!.sendFile(
  //       bytes,
  //       fileName: fileName,
  //       fileType: fileType,
  //       caption: message.value.trim().isNotEmpty ? message.value.trim() : null,
  //     );
  //
  //     // Clear caption if any
  //     if (message.value.trim().isNotEmpty) {
  //       message.value = '';
  //       textController.clear();
  //     }
  //
  //     debugPrint('File sent: $fileName');
  //   } catch (e) {
  //     debugPrint('Error sending file: $e');
  //     showCustomSnackBar(
  //       title: 'Error',
  //       message: 'Failed to send file',
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isFileUploading(false);
  //     isSending.value = false;
  //   }
  // }
  Future<void> openWithOtherUser({
    required int otherUserId,
    required int currentUserId,
  }) async {
    final ids = <int>{currentUserId, otherUserId}.toList();
    await openWithParticipants(ids);
  }

  Future<void> openWithParticipants(List<int> participants) async {
    chatError.value = '';
    if (participants.length < 2) {
      chatError.value = 'Need two participants';
      showCustomSnackBar(
        title: 'Error',
        message: chatError.value,
        isSuccess: false,
      );
      return;
    }
    final token = authController.accessToken.value;
    if (token.isEmpty) {
      chatError.value = 'Please log in';
      showCustomSnackBar(
        title: 'Error',
        message: chatError.value,
        isSuccess: false,
      );
      Get.offAllNamed('/login');
      return;
    }
    isRoomLoading(true);
    try {
      final res = await apiService.createOrGetChatRoom(
        token,
        participants: participants,
      );
      if (res['statusCode'] == 200) {
        final data = res['data'] as Map<String, dynamic>;
        roomId.value = (data['id'] as num).toInt();
        if (data['messages'] is List) {
          messages.assignAll(
            (data['messages'] as List).cast<Map<String, dynamic>>(),
          );
        } else {
          messages.clear();
        }
        Future.delayed(
          const Duration(milliseconds: 300),
              () => scrollToBottom(),
        );
      } else if (res['statusCode'] == 401) {
        final refreshed = await authController.refreshAccessToken();
        if (refreshed) {
          final newToken = await authController.getAccessToken();
          final retryRes = await apiService.createOrGetChatRoom(
            newToken!,
            participants: participants,
          );
          if (retryRes['statusCode'] == 200) {
            final data = retryRes['data'] as Map<String, dynamic>;
            roomId.value = (data['id'] as num).toInt();
            if (data['messages'] is List) {
              messages.assignAll(
                (data['messages'] as List).cast<Map<String, dynamic>>(),
              );
            } else {
              messages.clear();
            }
            Future.delayed(
              const Duration(milliseconds: 300),
                  () => scrollToBottom(),
            );
          } else {
            chatError.value =
                retryRes['data']['error'] ??
                    'Failed to open chat room after token refresh';
            showCustomSnackBar(
              title: 'Error',
              message: chatError.value,
              isSuccess: false,
            );
            Get.offAllNamed('/login');
          }
        } else {
          chatError.value = 'Failed to refresh token. Please log in again.';
          showCustomSnackBar(
            title: 'Error',
            message: chatError.value,
            isSuccess: false,
          );
          Get.offAllNamed('/login');
        }
      } else {
        chatError.value = res['data']['error'] ?? 'Failed to open chat room';
        showCustomSnackBar(
          title: 'Error',
          message: chatError.value,
          isSuccess: false,
        );
      }
    } catch (e, st) {
      debugPrint('openWithParticipants error: $e\n$st');
      chatError.value = 'Failed to open chat room: $e';
      showCustomSnackBar(
        title: 'Error',
        message: chatError.value,
        isSuccess: false,
      );
    } finally {
      isRoomLoading(false);
    }
  }

  // Future<bool> acceptInvitation(String invitationId, String name) async {
  //   try {
  //     final token = await storage.read(key: 'access_token');
  //     if (token == null) {
  //       debugPrint('Access token not found');
  //       _showErrorSnackbar(
  //         'Authentication token not found. Please log in again.',
  //       );
  //       Get.offAllNamed('/login');
  //       return false;
  //     }
  //     final invite = invitations.firstWhereOrNull(
  //           (inv) => inv['id'] == invitationId,
  //     );
  //     if (invite == null) {
  //       debugPrint('Invitation not found for ID: $invitationId');
  //       _showErrorSnackbar('Invitation not found');
  //       return false;
  //     }
  //     final senderId = invite['sender_id']!;
  //     debugPrint(
  //       'Accepting invitation ID: $invitationId for sender: $senderId',
  //     );
  //
  //     final respondResponse = await apiService.respondToInvitation(
  //       token,
  //       invitationId,
  //       'accept',
  //     );
  //     if (respondResponse['statusCode'] == 200) {
  //       final currentUserId =
  //           this.currentUserId ??
  //               Get.put(HomeController()).currentUserProfile.value.id ??
  //               await storage.read(key: 'user_id');
  //       if (currentUserId == null) {
  //         debugPrint('Current user ID not found');
  //         _showErrorSnackbar('User not logged in');
  //         Get.offAllNamed('/login');
  //         return false;
  //       }
  //
  //       // Remove the accepted invitation from the list
  //       invitations.removeWhere((inv) => inv['id'] == invitationId);
  //       updateLists(); // Update UI lists (names and images)
  //       lastInvitationsFetch = DateTime.now();
  //       _noInvitationsFound = invitations.isEmpty;
  //
  //       // Fetch updated chat rooms to reflect the new chat
  //       await fetchRooms();
  //
  //       // Notify user of success
  //       showCustomSnackBar(
  //         title: 'Success',
  //         message: 'Invitation from $name accepted successfully',
  //         isSuccess: true,
  //       );
  //       debugPrint('Invitation accepted successfully for sender: $senderId');
  //       return true;
  //     } else if (respondResponse['statusCode'] == 401) {
  //       final refreshed = await authController.refreshAccessToken();
  //       if (refreshed) {
  //         final newToken = await authController.getAccessToken();
  //         final retryRespondResponse = await apiService.respondToInvitation(
  //           newToken!,
  //           invitationId,
  //           'accept',
  //         );
  //         debugPrint('Retry accept invitation response: $retryRespondResponse');
  //         if (retryRespondResponse['statusCode'] == 200) {
  //           final currentUserId =
  //               this.currentUserId ??
  //                   Get.find<HomeController>().currentUserProfile.value.id ??
  //                   await storage.read(key: 'user_id');
  //           if (currentUserId == null) {
  //             debugPrint('Current user ID not found');
  //             _showErrorSnackbar('User not logged in');
  //             Get.offAllNamed('/login');
  //             return false;
  //           }
  //
  //           // Remove the accepted invitation from the list
  //           invitations.removeWhere((inv) => inv['id'] == invitationId);
  //           updateLists(); // Update UI lists (names and images)
  //           lastInvitationsFetch = DateTime.now();
  //           _noInvitationsFound = invitations.isEmpty;
  //
  //           // Fetch updated chat rooms to reflect the new chat
  //           await fetchRooms();
  //
  //           // Notify user of success
  //           showCustomSnackBar(
  //             title: 'Success',
  //             message: 'Invitation from $name accepted successfully',
  //             isSuccess: true,
  //           );
  //           debugPrint(
  //             'Invitation accepted successfully after token refresh for sender: $senderId',
  //           );
  //           return true;
  //         } else {
  //           debugPrint(
  //             'Retry failed to accept invitation: ${retryRespondResponse['data']['message']}',
  //           );
  //           _showErrorSnackbar(
  //             retryRespondResponse['data']['message'] ??
  //                 'Failed to accept invitation after token refresh',
  //           );
  //           Get.offAllNamed('/login');
  //           return false;
  //         }
  //       } else {
  //         debugPrint('Failed to refresh token');
  //         _showErrorSnackbar('Failed to refresh token. Please log in again.');
  //         Get.offAllNamed('/login');
  //         return false;
  //       }
  //     } else {
  //       debugPrint(
  //         'Failed to accept invitation: ${respondResponse['data']['message']}',
  //       );
  //       _showErrorSnackbar(
  //         respondResponse['data']['message'] ?? 'Failed to accept invitation',
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint('Error accepting invitation: $e');
  //     _showErrorSnackbar('Error accepting invitation: $e');
  //     return false;
  //   }
  // }

  Future<bool> rejectInvitation(String invitationId) async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        debugPrint('Access token not found');
        _showErrorSnackbar('Authentication token not found');
        return false;
      }
      debugPrint('Rejecting invitation ID: $invitationId');
      final response = await apiService.respondToInvitation(
        token,
        invitationId,
        'reject',
      );
      if (response['statusCode'] == 200) {
        invitations.removeWhere((inv) => inv['id'] == invitationId);
        updateLists();
        return true;
      } else if (response['statusCode'] == 401) {
        final refreshed = await authController.refreshAccessToken();
        if (refreshed) {
          final newToken = await authController.getAccessToken();
          final retryResponse = await apiService.respondToInvitation(
            newToken!,
            invitationId,
            'reject',
          );
          if (retryResponse['statusCode'] == 200) {
            invitations.removeWhere((inv) => inv['id'] == invitationId);
            updateLists();
            return true;
          } else {
            debugPrint(
              'Retry failed to reject invitation: ${retryResponse['data']['message']}',
            );
            _showErrorSnackbar(
              retryResponse['data']['message'] ??
                  'Failed to reject invitation after token refresh',
            );
            return false;
          }
        } else {
          debugPrint('Failed to refresh token');
          _showErrorSnackbar('Failed to refresh token. Please log in again.');
          Get.offAllNamed('/login');
          return false;
        }
      } else {
        debugPrint(
          'Failed to reject invitation: ${response['data']['message']}',
        );
        _showErrorSnackbar(
          response['data']['message'] ?? 'Failed to reject invitation',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error rejecting invitation: $e');
      _showErrorSnackbar('Error rejecting invitation: $e');
      return false;
    }
  }

  final errorMessage = ''.obs;
  String? nextPageUrl;
  bool hasMore = true;

  Future<void> fetchChats({
    bool reset = false,
    bool loadMore = false,
  }) async {
    try {
      if (reset) {
        nextPageUrl = null;
        hasMore = true;
        chats.clear();
        chatRooms.clear();
      } else if (loadMore) {
        if (!hasMore || isFetchingChats.value) return;
      }

      isFetchingChats.value = true;
      errorMessage.value = '';

      final token = await storage.read(key: 'access_token');
      currentUserId = await storage.read(key: 'user_id');
      if (token == null) {
        debugPrint('Access token not found');
        _showErrorSnackbar('Authentication token not found');
        return;
      }

      debugPrint('Fetching chats - Next URL: $nextPageUrl, HasMore: $hasMore');

      final response = await apiService.getChats(token, pageUrl: nextPageUrl);
      debugPrint('API Response Status: ${response['statusCode']}');

      if (response['statusCode'] == 200) {
        final data = response['data'] as Map<String, dynamic>;
        final chatList = data['results'] as List<dynamic>? ?? [];
        final next = data['next'] as String?;
        final totalCount = data['count'] as int?;

        debugPrint('Fetched ${chatList.length} chats from API');
        debugPrint('Next URL: $next');
        debugPrint('Total count: $totalCount');

        final newChats = chatList.map((chat) {
          final participants = chat['participants'] as List<dynamic>;
          final currentUser = chat['current_user'] as Map<String, dynamic>?;
          final userId = currentUser?['id']?.toString() ?? currentUserId;

          final otherParticipant = participants.firstWhere(
                (p) => p['id'].toString() != userId,
            orElse: () => {
              'id': '',
              'name': 'Unknown',
              'profile_image': '/images/default.jpg',
            },
          );

          String imageUrl = otherParticipant['profile_image']?.toString() ?? '/images/default.jpg';
          if (imageUrl.startsWith(Api.imageUrl)) {
            imageUrl = imageUrl.replaceFirst(Api.imageUrl, '');
            debugPrint('Normalized chat image URL to: $imageUrl');
          }

          final roomId = chat['id'].toString();
          final count = chat['unread_count'].toString();
          final recipientId = otherParticipant['id'].toString();
          if (recipientId != '') {
            chatRooms[recipientId] = roomId;
          }

          final lastMessage = chat['last_message'] as Map<String, dynamic>?;
          String lastMessageText = lastMessage?['content']?.toString() ?? '';
          String lastMessageTime = lastMessage?['timestamp_display']?.toString() ?? '';

          return {
            'id': roomId,
            'recipient_id': recipientId,
            'name': otherParticipant['name'].toString(),
            'image': imageUrl,
            'last_message': lastMessageText,
            'last_message_time': lastMessageTime,
            'count': count,
          };
        }).toList();

        // Filter out duplicates based on chat ID
        final existingChatIds = chats.map((chat) => chat['id'] as String).toSet();
        final uniqueNewChats = newChats.where((chat) => !existingChatIds.contains(chat['id'])).toList();

        if (reset) {
          chats.assignAll(uniqueNewChats);
        } else {
          chats.addAll(uniqueNewChats);
        }

        // Update pagination state
        hasMore = next != null && next.isNotEmpty;
        nextPageUrl = next;

        if (selectedTab.value == 'ChatHistory') {
          updateLists();
        }

        debugPrint('Total chats: ${chats.length}, chatRooms: ${chatRooms.length}, chatRooms: $chatRooms');
        lastChatsFetch = DateTime.now();
      } else if (response['statusCode'] == 401) {
        final refreshed = await authController.refreshAccessToken();
        if (refreshed) {
          return await fetchChats(reset: reset, loadMore: loadMore);
        } else {
          debugPrint('Failed to refresh token');
          errorMessage.value = 'Failed to refresh token. Please log in again.';
          _showErrorSnackbar('Failed to refresh token. Please log in again.');
          Get.offAllNamed('/login');
        }
      } else {
        final error = response['data']['detail'] ?? 'Failed to fetch chats';
        debugPrint('Failed to fetch chats: $error');
        errorMessage.value = error;
        _showErrorSnackbar(error);
        hasMore = false;
      }
    } catch (e) {
      debugPrint('Error fetching chats: $e');
      errorMessage.value = 'Error fetching chats: $e';
      _showErrorSnackbar('Error fetching chats: $e');
      hasMore = false;
    } finally {
      isFetchingChats.value = false;
    }
  }

  Future<void> fetchInvitations() async {
    isFetchingChats.value = true;
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        debugPrint('Access token not found');
        _showErrorSnackbar('Authentication token not found');
        return;
      }
      final response = await apiService.getInvitations(token);
      if (response['statusCode'] == 200) {
        final invites = response['data']['results'] as List<dynamic>;
        invitations.assignAll(
          invites.map((invite) {
            String imageUrl =
                invite['sender']['profile_image']?.toString() ??
                    '/images/default.jpg';
            if (imageUrl.startsWith(Api.imageUrl)) {
              imageUrl = imageUrl.replaceFirst(Api.imageUrl, '');
              debugPrint('Normalized invitation image URL to: $imageUrl');
            }
            return {
              'id': invite['id'].toString(),
              'sender_id': invite['sender']['id'].toString(),
              'name': invite['sender']['name'].toString(),
              'image': imageUrl,
            };
          }).toList(),
        );
        if (selectedTab.value == 'Invitations') {
          updateLists();
        }
        debugPrint('Fetched invitations: ${invitations.length}');
        lastInvitationsFetch = DateTime.now();
        _noInvitationsFound = invitations.isEmpty;
      } else if (response['statusCode'] == 401) {
        final refreshed = await authController.refreshAccessToken();
        if (refreshed) {
          final newToken = await authController.getAccessToken();
          final retryResponse = await apiService.getInvitations(newToken!);
          if (retryResponse['statusCode'] == 200) {
            final invites = retryResponse['data']['results'] as List<dynamic>;
            invitations.assignAll(
              invites.map((invite) {
                String imageUrl =
                    invite['sender']['profile_image']?.toString() ??
                        '/images/default.jpg';
                if (imageUrl.startsWith(Api.imageUrl)) {
                  imageUrl = imageUrl.replaceFirst(Api.imageUrl, '');
                  debugPrint('Normalized invitation image URL to: $imageUrl');
                }
                return {
                  'id': invite['id'].toString(),
                  'sender_id': invite['sender']['id'].toString(),
                  'name': invite['sender']['name'].toString(),
                  'image': imageUrl,
                };
              }).toList(),
            );
            if (selectedTab.value == 'Invitations') {
              updateLists();
            }
            debugPrint('Fetched invitations: ${invitations.length}');
            lastInvitationsFetch = DateTime.now();
            _noInvitationsFound = invitations.isEmpty;
          } else {
            debugPrint(
              'Retry failed to fetch invitations: ${retryResponse['data']['message']}',
            );
            _showErrorSnackbar(
              retryResponse['data']['message'] ??
                  'Failed to fetch invitations after token refresh',
            );
            Get.offAllNamed('/login');
          }
        } else {
          debugPrint('Failed to refresh token');
          _showErrorSnackbar('Failed to refresh token. Please log in again.');
          Get.offAllNamed('/login');
        }
      } else {
        debugPrint(
          'Failed to fetch invitations: ${response['data']['message']}',
        );
        _showErrorSnackbar(
          response['data']['message'] ?? 'Failed to fetch invitations',
        );
      }
    } catch (e) {
      debugPrint('Error fetching invitations: $e');
      _showErrorSnackbar('Error fetching invitations: $e');
    } finally {
      isFetchingChats.value = false;
    }
  }

  Future<void> fetchMessages(int roomId, {int page = 1}) async {
    final token = authController.accessToken.value;
    isMessageLoading(true);
    double? previousOffset;
    if (page > 1 && scrollController?.hasClients == true) {
      previousOffset = scrollController!.offset; // Store current offset
    }
    try {
      final response = await apiService.fetchMessages(roomId.toString(), token, page: page);
      debugPrint("fetchMessages Response: ${response['data']}");
      if (response['statusCode'] == 200) {
        final data = response['data'];
        if (data is Map<String, dynamic> && data.containsKey('messages')) {
          final List<dynamic> messageList = data['messages'] ?? [];
          final processedMessages = messageList.map((msg) {
            final message = Map<String, dynamic>.from(msg);
            if (message['image_url'] != null && message['image_url'] is String) {
              message['image'] = makeAbsolutePhoto(message['image_url']);
            }
            if (message['file_url'] != null && message['file_url'] is String) {
              message['file'] = makeAbsolutePhoto(message['file_url']);
            }
            return message;
          }).toList();

          if (page == 1) {
            // Initial load: replace messages
            messages.assignAll(processedMessages.cast<Map<String, dynamic>>());
          } else {
            // Prepend older messages and adjust scroll
            messages.insertAll(0, processedMessages.cast<Map<String, dynamic>>());
            if (scrollController?.hasClients == true && previousOffset != null) {
              // Estimate height of new messages (adjust based on your UI)
              final estimatedMessageHeight = 100.0; // Average height per message
              final newContentHeight = processedMessages.length * estimatedMessageHeight;
              final newOffset = previousOffset + newContentHeight;
              scrollController!.jumpTo(newOffset.clamp(0.0, scrollController!.position.maxScrollExtent));
            }
          }

          // Update pagination info
          currentPage.value = data['page'] ?? page;
          final totalMessages = data['total_messages'] ?? messageList.length;
          hasMoreMessages.value = (currentPage.value * (data['page_size'] ?? 50)) < totalMessages;

          debugPrint("✅ Messages loaded: ${messages.length}, Page: ${currentPage.value}, Has more: ${hasMoreMessages.value}");

          if (page == 1) {
            Future.delayed(
              const Duration(milliseconds: 300),
                  () => scrollToBottom(),
            );
          }
        } else {
          debugPrint("⚠ Unexpected format: $data");
          showCustomSnackBar(
            title: 'Error',
            message: 'Unexpected response format from server',
            isSuccess: false,
          );
        }
      } else if (response['statusCode'] == 401) {
        // ... existing token refresh logic remains unchanged ...
      } else {
        final errorMsg = response['data']?['error'] ?? 'Failed to load messages';
        debugPrint("fetchMessages Error: $errorMsg");
        showCustomSnackBar(title: 'Error', message: errorMsg, isSuccess: false);
      }
    } catch (e, st) {
      debugPrint('fetchMessages Exception: $e\n$st');
      showCustomSnackBar(
        title: 'Error',
        message: 'Failed to load messages: $e',
        isSuccess: false,
      );
    } finally {
      isMessageLoading(false);
    }
  }

  Future<void> fetchMoreMessages() async {
    if (!hasMoreMessages.value || isLoadingMoreMessages.value) return;
    isLoadingMoreMessages.value = true;
    await fetchMessages(currentRoomId!, page: currentPage.value + 1);
    isLoadingMoreMessages.value = false;
  }

  Future<void> fetchRooms() async {
    final token = authController.accessToken.value;
    roomsError.value = '';
    if (token.isEmpty) {
      roomsError.value = 'Please log in to view chats';
      showCustomSnackBar(
        title: 'Error',
        message: roomsError.value,
        isSuccess: false,
      );
      Get.offAllNamed('/login');
      return;
    }
    isRoomsLoading(true);
    try {
      final res = await apiService.getChats(token);
      if (res['statusCode'] == 200) {
        final list = (res['data'] as List).cast<Map<String, dynamic>>();
        for (final room in list) {
          if (room['participants'] is List) {
            final parts = room['participants'] as List;
            for (final p in parts) {
              if (p is Map && p['profile_photo'] is String) {
                p['profile_photo'] = makeAbsolutePhoto(p['profile_photo']);
              }
            }
          }
        }
        rooms.assignAll(list);
      } else if (res['statusCode'] == 401) {
        final refreshed = await authController.refreshAccessToken();
        if (refreshed) {
          final newToken = await authController.getAccessToken();
          final retryRes = await apiService.getChats(newToken!);
          if (retryRes['statusCode'] == 200) {
            final list =
            (retryRes['data'] as List).cast<Map<String, dynamic>>();
            for (final room in list) {
              if (room['participants'] is List) {
                final parts = room['participants'] as List;
                for (final p in parts) {
                  if (p is Map && p['profile_photo'] is String) {
                    p['profile_photo'] = makeAbsolutePhoto(p['profile_photo']);
                  }
                }
              }
            }
            rooms.assignAll(list);
          } else {
            roomsError.value =
                retryRes['data']['error'] ??
                    'Failed to load chat rooms after token refresh';
            showCustomSnackBar(
              title: 'Error',
              message: roomsError.value,
              isSuccess: false,
            );
            Get.offAllNamed('/login');
          }
        } else {
          roomsError.value = 'Failed to refresh token. Please log in again.';
          showCustomSnackBar(
            title: 'Error',
            message: roomsError.value,
            isSuccess: false,
          );
          Get.offAllNamed('/login');
        }
      } else {
        roomsError.value = res['data']['error'] ?? 'Failed to load chat rooms';
        showCustomSnackBar(
          title: 'Error',
          message: roomsError.value,
          isSuccess: false,
        );
      }
    } catch (e, st) {
      debugPrint('fetchRooms error: $e\n$st');
      roomsError.value = 'Failed to load chat rooms: $e';
      showCustomSnackBar(
        title: 'Error',
        message: roomsError.value,
        isSuccess: false,
      );
    } finally {
      isRoomsLoading(false);
    }
  }
}
