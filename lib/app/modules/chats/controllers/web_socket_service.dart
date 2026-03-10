import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../res/app_url/app_url.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String token;
  bool _isConnected = false;

  WebSocketService(this.token);

  bool get isConnected => _isConnected;

  // Connect to WebSocket
  void connect(
      int roomId, {
        required Function(Map<String, dynamic>) onMessage,
        Function(dynamic)? onError,
        Function()? onDone,
      }) {
    try {
      final uri = Uri.parse('${Api.webSocketUrl}/$roomId/?token=$token');
      debugPrint('Connecting to WebSocket: $uri');

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _channel!.stream.listen(
            (message) {
          try {
            debugPrint('WebSocket received: $message');
            final data = jsonDecode(message);
            debugPrint('web socket data type: ${data}');
            debugPrint('web socket data: $data');
            if (data is Map<String, dynamic>) {
              // Handle error messages from server
              if (data['type'] == 'error') {
                debugPrint('Server error: ${data['message']}');
                // Don't pass error messages as regular messages
                return;
              }
              onMessage(data);
            }
          } catch (e) {
            debugPrint('Error parsing WebSocket message: $e');
            onError?.call(e);
          }
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _isConnected = false;
          onError?.call(error);
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
          _isConnected = false;
          onDone?.call();
        },
      );

      // Send connection confirmation
      _sendConnectionMessage();
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _isConnected = false;
      onError?.call(e);
    }
  }

  // Send connection confirmation
  void _sendConnectionMessage() {
    if (!_isConnected || _channel == null) return;

    try {
      final data = jsonEncode({
        'action': 'connect',
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent connection message');
    } catch (e) {
      debugPrint('Error sending connection message: $e');
    }
  }

  // Send text message
  void sendMessage(String message) {
    if (!_isConnected || _channel == null) {
      debugPrint('WebSocket not connected');
      return;
    }

    try {
      final data = jsonEncode({
        'action': 'send_message',
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent message: $message');
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }
  // Send file/image with metadata
  void sendFile(
      Uint8List fileBytes, {
        required String fileName,
        required String fileType,
        String? caption,
      }) {
    if (!_isConnected || _channel == null) {
      debugPrint('WebSocket not connected');
      return;
    }

    try {
      // Convert file to base64 for JSON transmission
      final base64File = base64Encode(fileBytes);

      final data = jsonEncode({
        "action": "send_message",
        "message_type": fileType,
        "base64": base64File,
        "file_name": fileName,

        // "action": "send_message",
        // 'file': base64File,
        // 'file_name': fileName,
        // 'file_type': 'fileType',
        // 'caption': caption,
        // 'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent file: $fileName ($fileType)');
      debugPrint('Message image ID: $data');
    } catch (e) {
      debugPrint('Error sending file: $e');
    }
  }

  // Send image specifically
  void sendImage(
      Uint8List imageBytes, {
        required String fileName,
        String? caption,
      }) {
    sendFile(
      imageBytes,
      fileName: fileName,
      fileType: 'image',
      caption: caption,
    );
  }

  // Send voice message specifically
  void sendVoice(
      Uint8List voiceBytes, {
        required String fileName,
        String? caption,
      }) {
    sendFile(
      voiceBytes,
      fileName: fileName,
      fileType: 'voice',
      caption: caption,
    );
  }

  // Send typing indicator - Fixed to avoid invalid actions
  void sendTypingStatus(bool isTyping) {
    if (!_isConnected || _channel == null) return;

    try {
      // Only send typing status if server supports it
      // Use a more standard action name
      final data = jsonEncode({
        'action': 'typing',
        'typing': isTyping,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent typing status: $isTyping');
    } catch (e) {
      debugPrint('Error sending typing status: $e');
      // Silently fail if typing status is not supported
    }
  }

  // Send read receipt
  void sendReadReceipt(dynamic messageId) {
    if (!_isConnected || _channel == null) return;

    try {
      final data = jsonEncode({
        'action': 'read_receipt',
        'message_id': messageId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent read receipt for message: $messageId');
    } catch (e) {
      debugPrint('Error sending read receipt: $e');
    }
  }

  // Send online status
  void sendOnlineStatus(bool isOnline) {
    if (!_isConnected || _channel == null) return;

    try {
      final data = jsonEncode({
        'action': 'online_status',
        'online': isOnline,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent online status: $isOnline');
    } catch (e) {
      debugPrint('Error sending online status: $e');
    }
  }

  // Send message delivery confirmation
  void sendDeliveryConfirmation(dynamic messageId) {
    if (!_isConnected || _channel == null) return;

    try {
      final data = jsonEncode({
        'action': 'message_delivered',
        'message_id': messageId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent delivery confirmation for message: $messageId');
    } catch (e) {
      debugPrint('Error sending delivery confirmation: $e');
    }
  }

  // Send custom action
  void sendCustomAction(String action, Map<String, dynamic> payload) {
    if (!_isConnected || _channel == null) return;

    try {
      final data = jsonEncode({
        'action': action,
        ...payload,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent custom action: $action');
    } catch (e) {
      debugPrint('Error sending custom action: $e');
    }
  }

  // Disconnect
  void disconnect() {
    try {
      // Send disconnect message before closing
      if (_isConnected && _channel != null) {
        sendOnlineStatus(false);
        Future.delayed(const Duration(milliseconds: 100), () {
          _channel?.sink.close();
        });
      }
      _isConnected = false;
      debugPrint('WebSocket disconnected');
    } catch (e) {
      debugPrint('Error disconnecting WebSocket: $e');
    }
  }

  // Check connection status
  void checkConnection() {
    debugPrint('WebSocket connected: $_isConnected');
  }

  // Ping to keep connection alive
  void ping() {
    if (!_isConnected || _channel == null) return;

    try {
      final data = jsonEncode({
        'action': 'ping',
        'timestamp': DateTime.now().toIso8601String(),
      });

      _channel!.sink.add(data);
      debugPrint('Sent ping');
    } catch (e) {
      debugPrint('Error sending ping: $e');
    }
  }
}
