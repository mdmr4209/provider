class CoachSessionModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String clientName;
  final String clientAvatar;
  final String rate;

  CoachSessionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.clientName,
    required this.clientAvatar,
    required this.rate,
  });

  factory CoachSessionModel.fromJson(Map<String, dynamic> json) {
    return CoachSessionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      clientName: json['clientName'] ?? '',
      clientAvatar: json['clientAvatar'] ?? '',
      rate: json['rate'] ?? '',
    );
  }
}

class CoachMessageModel {
  final String id;
  final String senderName;
  final String senderAvatar;
  final String status;
  final String time;
  final String unreadCount;

  CoachMessageModel({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.status,
    required this.time,
    required this.unreadCount,
  });

  factory CoachMessageModel.fromJson(Map<String, dynamic> json) {
    return CoachMessageModel(
      id: json['id'] ?? '',
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'] ?? '',
      status: json['status'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unreadCount'] ?? '0',
    );
  }
}

class CoachStatsModel {
  final String callBackRequests;
  final String newMessages;
  final String missedCalls;
  final String netEarnings;
  final String earningsPeriod;

  CoachStatsModel({
    required this.callBackRequests,
    required this.newMessages,
    required this.missedCalls,
    required this.netEarnings,
    required this.earningsPeriod,
  });

  factory CoachStatsModel.fromJson(Map<String, dynamic> json) {
    return CoachStatsModel(
      callBackRequests: json['callBackRequests'] ?? '0',
      newMessages: json['newMessages'] ?? '0',
      missedCalls: json['missedCalls'] ?? '0',
      netEarnings: json['netEarnings'] ?? '\$0.00',
      earningsPeriod: json['earningsPeriod'] ?? 'This month',
    );
  }
}
