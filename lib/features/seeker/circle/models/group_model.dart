class GroupModel {
  final String id;
  final String name;
  final String icon;
  final int memberCount;
  final String description;
  final bool isJoined;
  final String? status;

  GroupModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.memberCount,
    required this.description,
    this.isJoined = false,
    this.status,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      description: json['description'] ?? '',
      isJoined: json['isJoined'] ?? false,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'memberCount': memberCount,
      'description': description,
      'isJoined': isJoined,
      'status': status,
    };
  }
}

class GroupInvitationModel {
  final String id;
  final GroupModel group;
  final String invitedBy;
  final String invitedAt;

  GroupInvitationModel({
    required this.id,
    required this.group,
    required this.invitedBy,
    required this.invitedAt,
  });

  factory GroupInvitationModel.fromJson(Map<String, dynamic> json) {
    return GroupInvitationModel(
      id: json['id'] ?? '',
      group: GroupModel.fromJson(json['group'] ?? {}),
      invitedBy: json['invitedBy'] ?? '',
      invitedAt: json['invitedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group': group.toJson(),
      'invitedBy': invitedBy,
      'invitedAt': invitedAt,
    };
  }
}

class GroupReportModel {
  final String id;
  final String reporterName;
  final String reportedUserName;
  final String category;
  final String content;
  final String status;

  GroupReportModel({
    required this.id,
    required this.reporterName,
    required this.reportedUserName,
    required this.category,
    required this.content,
    required this.status,
  });

  factory GroupReportModel.fromJson(Map<String, dynamic> json) {
    return GroupReportModel(
      id: json['id'] ?? '',
      reporterName: json['reporterName'] ?? '',
      reportedUserName: json['reportedUserName'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterName': reporterName,
      'reportedUserName': reportedUserName,
      'category': category,
      'content': content,
      'status': status,
    };
  }
}
