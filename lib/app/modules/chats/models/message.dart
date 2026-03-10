class Message {
  final String id;
  final String? senderId;
  final String content;
  final bool isImage;
  final DateTime timestamp;
  final String senderImage;
  final bool isRead;

  Message({
    required this.id,
    this.senderId,
    required this.content,
    required this.isImage,
    required this.timestamp,
    required this.senderImage,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      senderId: json['sender_id']?.toString() ?? json['sender']?['id']?.toString(),
      content: json['content']?.toString() ?? '',
      isImage: json['is_image'] ?? false,
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'])
          : json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.now(),
      senderImage: json['sender']?['profile_image']?.toString() ??
          json['sender_image']?.toString() ??
          '/images/default.jpg',
      isRead: json['is_read'] ?? false,
    );
  }
}