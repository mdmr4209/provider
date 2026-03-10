import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../res/app_url/app_url.dart';
import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../auth/providers/auth_controller.dart';
import '../controllers/chats_controller.dart';
import 'full_screen_image_view.dart';

class PersonalChat extends StatefulWidget {
  final String name;
  final String? image;
  final int? roomId;

  const PersonalChat({super.key, required this.name, this.image, this.roomId});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat>
    with TickerProviderStateMixin {
  final ChatsController controller = Get.find<ChatsController>();
  final AuthController authController = Get.put(AuthController());
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFocusNode = FocusNode();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Voice recording variables
  bool isRecording = false;
  bool isPlaying = false;
  AnimationController? _typingAnimationController;

  // Voice recording service (you'll need to implement this)
  // VoiceRecordingService? _voiceService;

  @override
  void initState() {
    super.initState();

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    controller.setScrollController(_scrollController);

    if (widget.roomId != null) {
      controller.initializeChat(widget.roomId!);
    }
    print('start scroll');
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.scrollToBottom1();
    });
    _textFocusNode.addListener(() {
      if (_textFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          controller.scrollToBottom();
        });
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.offset == 0) {
        debugPrint('im top');
        controller.fetchMoreMessages();
      }
    });
    // Listen to typing indicator
    ever(controller.isRecipientTyping, (isTyping) {
      if (isTyping) {
        _typingAnimationController?.repeat();
      } else {
        _typingAnimationController?.stop();
      }
    });

    // ever(controller.messages, (messages) {
    //   Future.delayed(const Duration(milliseconds: 100), () {
    //     controller.scrollToBottom();
    //   });
    // });
  }

  @override
  void dispose() {
    controller.cleanupChat();
    _scrollController.dispose();
    _textFocusNode.dispose();
    _typingAnimationController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        await controller.sendImage(file: file);
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        await controller.sendFile(file);
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  Future<void> _pickVideoOrImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (file != null) {
        final fileExtension = file.path.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
          final imageFile = File(file.path);
          await controller.sendImage(file: imageFile);
        } else {
          _showError('Unsupported file type');
        }
      }
    } catch (e) {
      _showError('Failed to pick media: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showFullImage(dynamic image) {
    if (image == null) return;
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: SizedBox(
            width: double.infinity,
            height: 0.8.sh,
            child:
            image is File
                ? Image.file(
              image,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                Icons.error,
                color: Colors.white,
                size: 50,
              ),
            )
                : CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.contain,
              placeholder:
                  (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget:
                  (context, url, error) => const Icon(
                Icons.error,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String _getDateHeader(String? timestamp) {
    if (timestamp == null) return 'Today';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else {
        return DateFormat('MMMM d, y').format(dateTime);
      }
    } catch (e) {
      return 'Today';
    }
  }

  Widget _buildFilePreview(Map<String, dynamic> message) {
    var count = 1;
    debugPrint('Message index $count: $message');
    count++;
    final fileName = message['file_name'] as String?;
    final fileType = message['file_type'] as String?;
    var fileUrl =
    message['image_url'] != null
        ? "${Api.imageUrl}${message['image_url']}"
        : "${Api.imageUrl}${message['image']}";

    if (fileName == null) return const SizedBox.shrink();

    final extension = fileName.split('.').last.toLowerCase();
    IconData fileIcon;
    Color fileColor;

    switch (fileType?.toLowerCase() ?? extension) {
      case 'image':
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        fileIcon = Icons.image;
        fileColor = Colors.green;
        break;
      case 'video':
      case 'mp4':
      case 'avi':
      case 'mov':
        fileIcon = Icons.videocam;
        fileColor = Colors.red;
        break;
      case 'audio':
      case 'voice':
      case 'mp3':
      case 'wav':
      case 'm4a':
        fileIcon = Icons.audiotrack;
        fileColor = Colors.orange;
        break;
      case 'document':
      case 'pdf':
        fileIcon = Icons.picture_as_pdf;
        fileColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        fileIcon = Icons.description;
        fileColor = Colors.blue;
        break;
      default:
        fileIcon = Icons.attach_file;
        fileColor = Colors.grey;
    }

    final isImage = [
      'image',
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
    ].contains(fileType?.toLowerCase() ?? extension);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isImage) Icon(fileIcon, color: fileColor, size: 24.sp),
        if (!isImage) SizedBox(width: 8.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isImage)
                if (isImage)
                  GestureDetector(
                    onTap: () {
                      Get.to(
                            () => FullScreenImageView(
                          imageUrl: fileUrl,
                          fileName: fileName,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.r),
                      child: Image.network(
                        fileUrl,
                        height: 120.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              if (!isImage)
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (fileType != null && !isImage)
                Text(
                  fileType.toUpperCase(),
                  style: TextStyle(fontSize: 12.sp, color: AppColor.greyTone),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    final content = message['content'] ?? '';
    final timestamp = message['timestamp'] as String?;
    final image = message['image_url'];
    final hasImage =
        image != null && (image is String && image.isNotEmpty || image is File);
    final hasFile = message['file_name'] != null;
    final fileType = message['file_type'] as String?;
    debugPrint('images: $image');
    return GestureDetector(
      onTap: hasImage ? () => _showFullImage(image) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        margin: EdgeInsets.only(
          bottom: 8.h,
          left: isMe ? 60.w : 0,
          right: isMe ? 0 : 60.w,
        ),
        decoration: ShapeDecoration(
          color: isMe ? AppColor.defaultColor : AppColor.containerColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.50.w, color: const Color(0xFFD2D6E4)),
            borderRadius:
            isMe
                ? BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            )
                : BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image content
            if (hasImage && !hasFile) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child:
                image is File
                    ? Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: 200.w,
                  height: 200.h,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                    width: 200.w,
                    height: 200.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                )
                    : CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  width: 200.w,
                  height: 200.h,
                  placeholder:
                      (context, url) => Container(
                    width: 200.w,
                    height: 200.h,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget:
                      (context, url, error) => Container(
                    width: 200.w,
                    height: 200.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              if (content.isNotEmpty) SizedBox(height: 8.h),
            ],

            // File content
            if (hasFile) ...[
              _buildFilePreview(message),
              if (content.isNotEmpty) SizedBox(height: 8.h),
            ],

            // Text content
            if (content.isNotEmpty) ...[
              SelectableText(
                content,
                style: TextStyle(
                  fontSize: 16.sp,
                  color:
                  isMe ? AppColor.whiteTextColor : AppColor.blackColor,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 4.h),
            ],

            // Timestamp and read status
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatTime(timestamp),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color:
                    isMe
                        ? AppColor.whiteTextColor
                        : AppColor.blackColor,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    message['is_read'] == true ? Icons.done_all : Icons.done,
                    size: 12.sp,
                    color:
                    message['is_read'] == true
                        ? AppColor.heightBorderColor
                        : AppColor.greyTone,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Obx(() {
      if (!controller.isRecipientTyping.value) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.only(left: 16.w, right: 60.w, bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColor.softBeige,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.name} is typing',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.greyTone,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 8.w),
            AnimatedBuilder(
              animation: _typingAnimationController!,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final value = (_typingAnimationController!.value - delay)
                        .clamp(0.0, 1.0);
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          -10 * (0.5 - (0.5 - value).abs()) * 2,
                        ),
                        child: Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: AppColor.greyTone,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose attachment',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.blackColor,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.blue,
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.green,
                  onTap: () {
                    Get.back();
                    _pickVideoOrImageFromGallery();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.attach_file,
                  label: 'File',
                  color: Colors.orange,
                  onTap: () {
                    Get.back();
                    _pickFile();
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, size: 24.sp, color: color),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: AppColor.blackColor),
          ),
        ],
      ),
    );
  }

  @override
  // Fixed section for personal_chat.dart
  // Replace the build method's ListView.builder section with this:
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: storage.read(key: 'user_id'), // resolve Future here
      builder: (context, snapshot) {
        final currentUserId = snapshot.data;
        debugPrint('PersonalChat - Current User ID: $currentUserId');

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.black25),
            ),
            leadingWidth: 40.w,
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColor.greyTone,
                  child: ClipOval(
                    child: (widget.image != null && widget.image!.isNotEmpty)
                        ? CachedNetworkImage(
                      imageUrl: widget.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (_, __, ___) => Image.asset(
                        ImageAssets.avatar,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                        : Image.asset(
                      ImageAssets.avatar,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: AppColor.darkGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Obx(() {
                        if (controller.isRecipientTyping.value) {
                          return Text(
                            'typing...',
                            style: TextStyle(
                              color: AppColor.vividBlue,
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        } else if (controller.isRecipientOnline.value) {
                          return Text(
                            'online',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: _buildChatBody(currentUserId), // <-- extract your existing Column
        );
      },
    );
  }

  Widget _buildChatBody(String? currentUserId) {
    return Column(
      children: [
        Obx(
              () =>
          controller.isMessageLoading.value
              ? Container(
            width: double.infinity,
            color: Colors.blue[100],
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Text(
              'Loading messages...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.blue[700],
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: Obx(() {
            if (controller.messages.isEmpty &&
                !controller.isMessageLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64.sp,
                      color: AppColor.greyTone,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No messages yet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.greyTone,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Start a conversation!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.greyTone.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            String? lastDate;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      String messageSenderId = '';

                      if (message['sender'] is Map<String, dynamic>) {
                        final senderMap =
                        message['sender'] as Map<String, dynamic>;
                        messageSenderId = senderMap['id']?.toString() ?? '';
                        if (messageSenderId.isEmpty) {
                          messageSenderId =
                              message['sender']['user_id'].toString();
                        }
                        debugPrint('Message sender ID 1: $messageSenderId');
                      } else if (messageSenderId.isEmpty) {
                        messageSenderId =
                            message['sender']['user_id'].toString();
                        debugPrint('Message sender ID 2: $messageSenderId');
                      } else if (message['sender'] != null) {
                        messageSenderId =
                            message['sender']['user_id'].toString();
                      }

                      // Debug print for troubleshooting
                      debugPrint(
                        'Message ${message['id']}: sender_id=$messageSenderId, current_user=$currentUserId',
                      );

                      bool isMe;
                      if (messageSenderId.isEmpty) {
                        isMe = true;
                      } else {
                        isMe = messageSenderId == currentUserId;
                      }
                      print("isMe ________________ $isMe");
                      final timestamp = message['timestamp'] as String?;
                      final currentDate = _getDateHeader(timestamp);

                      bool showDateHeader = false;
                      if (currentDate != lastDate) {
                        showDateHeader = true;
                        lastDate = currentDate;
                      }
                      return Column(
                        children: [
                          if (showDateHeader)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: AppColor.softBeige),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Text(
                                      currentDate,
                                      style: TextStyle(
                                        color: AppColor.beigeBrown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: AppColor.softBeige),
                                  ),
                                ],
                              ),
                            ),
                          Align(
                            alignment:
                            isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: _buildMessageBubble(message, isMe),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildTypingIndicator(),
              ],
            );
          }),
        ),
        Obx(
              () =>
          controller.isuserblocked.value
              ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            child: Text(
              'Unblock User to continue Chat',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColor.greyTone,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : _buildInputBar(context),
        ),
      ],
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
                () =>
            controller.message.value.isEmpty
                ? Row(
              children: [
                GestureDetector(
                  onTap: _pickVideoOrImageFromGallery,
                  child: SvgPicture.asset(
                    ImageAssets.camera,
                    width: 28.w,
                    height: 28.h,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: _showAttachmentOptions,
                      child: SvgPicture.asset(
                        ImageAssets.gallery,
                        width: 28.w,
                        height: 28.h,
                      ),
                    ),
                  ],
                ),
              ],
            )
                : const SizedBox.shrink(),
          ),
          SizedBox(width: controller.message.value.isEmpty ? 10.w : 0),
          Expanded(
            child: TextField(
              controller: controller.textController,
              focusNode: _textFocusNode,
              onChanged: (value) {
                controller.onTextChanged(value);
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.scrollToBottom();
                });
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message...',
                hintStyle: TextStyle(color: AppColor.greyTone, fontSize: 14.sp),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
            ),
          ),
          Obx(
                () =>
            controller.message.value.isEmpty
                ? Text('')
                : Obx(
                  () =>
              controller.isSending.value
                  ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.vividBlue,
                  ),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  controller.sendMessage();
                  _textFocusNode.requestFocus();
                  Future.delayed(
                    const Duration(milliseconds: 200),
                        () {
                      controller.scrollToBottom();
                    },
                  );
                },
                child: SvgPicture.asset(
                  ImageAssets.send,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
