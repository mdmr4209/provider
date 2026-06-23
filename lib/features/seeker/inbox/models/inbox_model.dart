class StoryModel {
  final String name;
  final String avatar;
  final bool isMine;

  StoryModel({
    required this.name,
    required this.avatar,
    this.isMine = false,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      isMine: json['isMine'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'isMine': isMine,
    };
  }
}

class ChatSummaryModel {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isCoach;

  ChatSummaryModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.isCoach,
  });

  factory ChatSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChatSummaryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      isCoach: json['isCoach'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'lastMessage': lastMessage,
      'time': time,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'isCoach': isCoach,
    };
  }
}

class ChatMessageModel {
  final String sender;
  final String avatar;
  final String text;
  final bool isMe;
  final String time;

  ChatMessageModel({
    required this.sender,
    required this.avatar,
    required this.text,
    required this.isMe,
    required this.time,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      sender: json['sender'] ?? '',
      avatar: json['avatar'] ?? '',
      text: json['text'] ?? '',
      isMe: json['isMe'] ?? false,
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'avatar': avatar,
      'text': text,
      'isMe': isMe,
      'time': time,
    };
  }

  ChatMessageModel copyWith({
    String? sender,
    String? avatar,
    String? text,
    bool? isMe,
    String? time,
  }) {
    return ChatMessageModel(
      sender: sender ?? this.sender,
      avatar: avatar ?? this.avatar,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
    );
  }
}
