import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Pagination state
  int _groupsPage = 1;
  bool _groupsHasMore = true;
  bool _isFetchingMoreGroups = false;

  int _suggestionsPage = 1;
  bool _suggestionsHasMore = true;
  bool _isFetchingMoreSuggestions = false;

  List<GroupModel> get myGroups => _myGroups;
  List<GroupModel> get suggestedGroups => _suggestedGroups;
  List<GroupInvitationModel> get invitations => _invitations;
  List<GroupReportModel> get reports => _reports;
  GroupModel? get activeGroupDetails => _activeGroupDetails;
  List<Map<String, String>> get friendsToInvite => _friendsToInvite;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isFetchingMoreGroups => _isFetchingMoreGroups;
  bool get isFetchingMoreSuggestions => _isFetchingMoreSuggestions;

  bool get groupsHasMore => _groupsHasMore;
  bool get suggestionsHasMore => _suggestionsHasMore;

  Future<void> fetchGroupsData({bool isRefresh = false, bool isFetchMore = false, String tab = 'myGroups'}) async {
    if (isRefresh) {
      _isRefreshing = true;
      _groupsPage = 1;
      _groupsHasMore = true;
      _suggestionsPage = 1;
      _suggestionsHasMore = true;
    } else if (isFetchMore) {
      if (tab == 'myGroups' && !_groupsHasMore) return;
      if (tab == 'findGroups' && !_suggestionsHasMore) return;

      if (tab == 'myGroups') _isFetchingMoreGroups = true;
      if (tab == 'findGroups') _isFetchingMoreSuggestions = true;
    } else {
      _isLoading = true;
      _groupsPage = 1;
      _groupsHasMore = true;
      _suggestionsPage = 1;
      _suggestionsHasMore = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final String jsonString = await rootBundle.loadString('assets/json/group.json');
      final Map<String, dynamic> rawData = jsonDecode(jsonString);

      // Process My Groups
      if (tab == 'myGroups' || !isFetchMore) {
        final allGroups = (rawData['groups']['results'] as List).map((x) => GroupModel.fromJson(x)).toList();
        final startIndex = (_groupsPage - 1) * 10;
        final endIndex = startIndex + 10;
        final slice = allGroups.sublist(
          startIndex > allGroups.length ? allGroups.length : startIndex,
          endIndex > allGroups.length ? allGroups.length : endIndex,
        );

        if (isRefresh || (!isFetchMore && !isRefresh)) {
          _myGroups = slice;
        } else if (isFetchMore) {
          _myGroups.addAll(slice);
        }

        if (slice.length < 10 || endIndex >= allGroups.length) {
          _groupsHasMore = false;
        }
        if (isFetchMore && tab == 'myGroups') _groupsPage++;
      }

      // Process Suggested Groups
      if (tab == 'findGroups' || !isFetchMore) {
        final allSuggestions = (rawData['suggestions']['results'] as List).map((x) => GroupModel.fromJson(x)).toList();
        final startIndex = (_suggestionsPage - 1) * 10;
        final endIndex = startIndex + 10;
        final slice = allSuggestions.sublist(
          startIndex > allSuggestions.length ? allSuggestions.length : startIndex,
          endIndex > allSuggestions.length ? allSuggestions.length : endIndex,
        );

        if (isRefresh || (!isFetchMore && !isRefresh)) {
          _suggestedGroups = slice;
        } else if (isFetchMore) {
          _suggestedGroups.addAll(slice);
        }

        if (slice.length < 10 || endIndex >= allSuggestions.length) {
          _suggestionsHasMore = false;
        }
        if (isFetchMore && tab == 'findGroups') _suggestionsPage++;
      }

      // Process Invitations (no pagination implemented for simplicity, just reading the new structure)
      if (!isFetchMore) {
        _invitations = (rawData['invitations']['results'] as List).map((x) => GroupInvitationModel.fromJson(x)).toList();
      }

    } catch (e) {
      debugPrint("Error loading group data: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      _isFetchingMoreGroups = false;
      _isFetchingMoreSuggestions = false;
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
