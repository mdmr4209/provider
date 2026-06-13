class CoachClientModel {
  final String id;
  final String name;
  final String avatar;
  final String status;
  final String time;
  final String unreadCount;

  CoachClientModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.time,
    required this.unreadCount,
  });

  factory CoachClientModel.fromJson(Map<String, dynamic> json) {
    return CoachClientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      status: json['status'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unreadCount'] ?? '0',
    );
  }
}

class CoachMissedCallModel {
  final String id;
  final String name;
  final String avatar;
  final String timeRequested;

  CoachMissedCallModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.timeRequested,
  });

  factory CoachMissedCallModel.fromJson(Map<String, dynamic> json) {
    return CoachMissedCallModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      timeRequested: json['timeRequested'] ?? '',
    );
  }
}

class CoachCallbackModel {
  final String id;
  final String name;
  final String avatar;
  final String timeRequested;
  final String rate;

  CoachCallbackModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.timeRequested,
    required this.rate,
  });

  factory CoachCallbackModel.fromJson(Map<String, dynamic> json) {
    return CoachCallbackModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      timeRequested: json['timeRequested'] ?? '',
      rate: json['rate'] ?? 'Free',
    );
  }
}
