import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class GroupController extends ChangeNotifier {
  List<GroupModel> _myGroups = [];
  List<GroupModel> _suggestedGroups = [];
  List<GroupInvitationModel> _invitations = [];
  List<GroupReportModel> _reports = [];
  GroupModel? _activeGroupDetails;
  List<Map<String, String>> _friendsToInvite = [];

  bool _isLoading = false;
  bool _isRefreshing = false;

  List<GroupModel> get myGroups => _myGroups;
  List<GroupModel> get suggestedGroups => _suggestedGroups;
  List<GroupInvitationModel> get invitations => _invitations;
  List<GroupReportModel> get reports => _reports;
  GroupModel? get activeGroupDetails => _activeGroupDetails;
  List<Map<String, String>> get friendsToInvite => _friendsToInvite;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  Future<void> fetchGroupsData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // Mock dynamic JSON response based on 5.1, 5.2, 5.3
      final Map<String, dynamic> rawMyGroups = {
        "groups": [
          {
            "id": "group_001",
            "name": "No Contact Warriors",
            "icon": "https://api.dicebear.com/7.x/avataaars/svg?seed=group1",
            "memberCount": 1243,
            "description": "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
            "isJoined": true
          },
          {
            "id": "group_002",
            "name": "Healing Hearts",
            "icon": "https://api.dicebear.com/7.x/avataaars/svg?seed=group2",
            "memberCount": 856,
            "description": "A safe space for those healing from heartbreak. We support each other through the journey.",
            "isJoined": true
          }
        ]
      };

      final Map<String, dynamic> rawSuggestions = {
        "suggestions": [
          {
            "id": "group_003",
            "name": "Self Love Club",
            "icon": "https://api.dicebear.com/7.x/avataaars/svg?seed=group3",
            "memberCount": 3201,
            "description": "Focusing on self-growth and appreciation. You are enough.",
            "isJoined": false
          },
          {
            "id": "group_004",
            "name": "Mindful Living",
            "icon": "https://api.dicebear.com/7.x/avataaars/svg?seed=group4",
            "memberCount": 1540,
            "description": "Daily mindfulness practices and support for a peaceful mind.",
            "isJoined": false
          }
        ]
      };

      final Map<String, dynamic> rawInvitations = {
        "invitations": [
          {
            "id": "inv_001",
            "group": {
              "id": "group_001",
              "name": "No Contact Warriors",
              "icon": "https://api.dicebear.com/7.x/avataaars/svg?seed=group1",
              "memberCount": 1243,
              "description": "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!"
            },
            "invitedBy": "Sarah M.",
            "invitedAt": "2026-06-05T10:00:00Z"
          }
        ]
      };

      _myGroups = (rawMyGroups['groups'] as List).map((x) => GroupModel.fromJson(x)).toList();
      _suggestedGroups = (rawSuggestions['suggestions'] as List).map((x) => GroupModel.fromJson(x)).toList();
      _invitations = (rawInvitations['invitations'] as List).map((x) => GroupInvitationModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load groups: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchGroupDetails(String groupId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final Map<String, dynamic> rawDetail = {
        "id": groupId,
        "name": groupId == "group_002" ? "Healing Hearts" : "No Contact Warriors",
        "icon": groupId == "group_002" 
            ? "https://api.dicebear.com/7.x/avataaars/svg?seed=group2" 
            : "https://api.dicebear.com/7.x/avataaars/svg?seed=group1",
        "memberCount": groupId == "group_002" ? 856 : 1243,
        "description": groupId == "group_002" 
            ? "A safe space for those healing from heartbreak. We support each other through the journey." 
            : "Day 14 of No Contact. It was really hard today today, I almost texted him when I saw his favorite song playing. But I stayed strong!",
        "isJoined": true
      };

      _activeGroupDetails = GroupModel.fromJson(rawDetail);
    } catch (e) {
      showErrorSnackBar(message: "Failed to load group details: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchGroupReports({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final Map<String, dynamic> rawReports = {
        "reports": [
          {
            "id": "rep_1",
            "reporterName": "Miles Esther",
            "reportedUserName": "Coach Pearl",
            "category": "Harassment",
            "content": "Amazon Alexa Shopping is seeking a talented...",
            "status": "pending"
          },
          {
            "id": "rep_2",
            "reporterName": "Thomas stieve",
            "reportedUserName": "Sarah M.",
            "category": "Spam",
            "content": "Post contains repetitive unhelpful links.",
            "status": "reviewed"
          }
        ]
      };

      _reports = (rawReports['reports'] as List).map((x) => GroupReportModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load reports: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchFriendsToInvite({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _friendsToInvite = [
        {"id": "f_1", "name": "Miles Esther", "avatar": "https://i.pravatar.cc/150?u=miles"},
        {"id": "f_2", "name": "Sarah Jenkins", "avatar": "https://i.pravatar.cc/150?u=sarah_j"},
        {"id": "f_3", "name": "Mike Tyson", "avatar": "https://i.pravatar.cc/150?u=mike"},
      ];
    } catch (e) {
      showErrorSnackBar(message: "Failed to load friends list: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<bool> joinGroup(String groupId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      showSuccessSnackBar(message: "Successfully joined group!");
      // Refetch group lists to update state
      await fetchGroupsData();
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to join group: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> leaveGroup(String groupId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      showSuccessSnackBar(message: "Successfully left group.");
      await fetchGroupsData();
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to leave group: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createGroup(String name, String instruction, String logoUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      showSuccessSnackBar(message: "Group created successfully!");
      await fetchGroupsData();
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to create group: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
