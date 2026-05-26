class DashboardModel {
  final String? status;
  final DashboardData? data;

  DashboardModel({this.status, this.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      status: json['status'],
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
  final UserData? user;
  final TimerData? timer;
  final DailyWisdom? dailyWisdom;
  final JournalData? journal;
  final NotificationsData? notifications;

  DashboardData({
    this.user,
    this.timer,
    this.dailyWisdom,
    this.journal,
    this.notifications,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      timer: json['timer'] != null ? TimerData.fromJson(json['timer']) : null,
      dailyWisdom: json['dailyWisdom'] != null
          ? DailyWisdom.fromJson(json['dailyWisdom'])
          : null,
      journal: json['journal'] != null ? JournalData.fromJson(json['journal']) : null,
      notifications: json['notifications'] != null
          ? NotificationsData.fromJson(json['notifications'])
          : null,
    );
  }
}

class UserData {
  final String? name;
  final String? status;

  UserData({this.name, this.status});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      status: json['status'],
    );
  }
}

class TimerData {
  final int? days;
  final int? hours;
  final int? mins;
  final String? startDate;

  TimerData({this.days, this.hours, this.mins, this.startDate});

  factory TimerData.fromJson(Map<String, dynamic> json) {
    return TimerData(
      days: json['days'],
      hours: json['hours'],
      mins: json['mins'],
      startDate: json['startDate'],
    );
  }

  double get progress {
    // Dummy logic for progress calculation or use a field if available
    return 0.8; 
  }
}

class DailyWisdom {
  final String? quote;
  final String? author;

  DailyWisdom({this.quote, this.author});

  factory DailyWisdom.fromJson(Map<String, dynamic> json) {
    return DailyWisdom(
      quote: json['quote'],
      author: json['author'],
    );
  }
}

class JournalData {
  final String? prompt;
  final String? actionText;

  JournalData({this.prompt, this.actionText});

  factory JournalData.fromJson(Map<String, dynamic> json) {
    return JournalData(
      prompt: json['prompt'],
      actionText: json['actionText'],
    );
  }
}

class NotificationsData {
  final int? unreadCount;

  NotificationsData({this.unreadCount});

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    return NotificationsData(
      unreadCount: json['unreadCount'],
    );
  }
}
