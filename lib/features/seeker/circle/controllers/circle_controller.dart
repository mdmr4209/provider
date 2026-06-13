import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';
import '../models/circle_post_model.dart';
import '../models/user_profile_model.dart';

class CircleController extends ChangeNotifier {
  List<CirclePostModel> _posts = [];
  List<SuggestionModel> _members = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _friendRequests = [];
  List<Map<String, dynamic>> _followers = [];
  List<Map<String, dynamic>> _following = [];
  List<SuggestionModel> _discoverSuggestions = [];
  UserProfileModel? _selectedUserProfile;

  List<CirclePostModel> get posts => _posts;
  List<SuggestionModel> get members => _members;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  List<Map<String, dynamic>> get friends => _friends;
  List<Map<String, dynamic>> get friendRequests => _friendRequests;
  List<Map<String, dynamic>> get followers => _followers;
  List<Map<String, dynamic>> get following => _following;
  List<SuggestionModel> get discoverSuggestions => _discoverSuggestions;
  UserProfileModel? get selectedUserProfile => _selectedUserProfile;

  // ── New Post State ──────────────────────────────────────────────────────
  final TextEditingController postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  /// Selected media files (images or videos) from the device for the new post.
  final List<XFile> _selectedMedia = [];
  List<XFile> get selectedMedia => _selectedMedia;

  /// Pick media from the device gallery.
  Future<void> pickMedia({bool isVideo = false}) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          _selectedMedia.add(video);
          notifyListeners();
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          _selectedMedia.addAll(images);
          notifyListeners();
        }
      }
    } catch (e) {
      showErrorSnackBar(message: "Failed to pick media: $e");
    }
  }

  /// Remove a selected media by index.
  void removeMedia(int index) {
    _selectedMedia.removeAt(index);
    notifyListeners();
  }

  /// Clear all new-post state.
  void clearNewPost() {
    postTextController.clear();
    _selectedMedia.clear();
    notifyListeners();
  }

  // ── Create Post ─────────────────────────────────────────────────────────
  Future<bool> createPost() async {
    if (postTextController.text.trim().isEmpty && _selectedMedia.isEmpty) {
      showErrorSnackBar(message: "Please add some content or media.");
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Mock API call delay
      await Future.delayed(const Duration(seconds: 1));

      final newPost = CirclePostModel(
        id: "post_${DateTime.now().millisecondsSinceEpoch}",
        userName: "joshua_l",
        userAvatar: "https://xsgames.co/randomusers/assets/avatars/male/5.jpg",
        timeAgo: "Just now",
        content: postTextController.text.trim(),
        likes: 0,
        claps: 0,
        isLiked: false,
        isClapped: false,
        isOwnPost: true,
        commentsCount: 0,
        images: _selectedMedia.isNotEmpty ? _selectedMedia.map((e) => e.path).toList() : null,
      );

      _posts.insert(0, newPost);
      clearNewPost();
      showSuccessSnackBar(message: "Post created successfully!");
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to create post: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch Circle Data ───────────────────────────────────────────────────
  Future<void> fetchCircleData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));
    // Simulating API call with dummy data
    _posts = CirclePostModel.dummyPosts;
    _members = SuggestionModel.dummySuggestions;

    _isLoading = false;
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> fetchSocialLists({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final Map<String, dynamic> rawSocial = {
        "friends": [
          { "id": "u1", "name": "Miles Esther", "avatar": "https://i.pravatar.cc/150?u=miles", "isOnline": true, "lastActive": "09:30 PM", "unreadCount": 2 },
          { "id": "u2", "name": "Thomas stieve", "avatar": "https://i.pravatar.cc/150?u=thomas", "isOnline": false, "lastActive": "12 April, 1:30AM", "unreadCount": 0 },
          { "id": "u3", "name": "Sarah Jenkins", "avatar": "https://i.pravatar.cc/150?u=sarah_j", "isOnline": true, "lastActive": "08:15 PM", "unreadCount": 0 }
        ],
        "requests": [
          { "id": "req1", "userId": "u4", "userName": "Mike Lee", "avatar": "https://i.pravatar.cc/150?u=mike_l", "mutualFriends": 2 },
          { "id": "req2", "userId": "u5", "userName": "Jordan K.", "avatar": "https://i.pravatar.cc/150?u=jordan", "mutualFriends": 3 }
        ],
        "followers": [
          { "id": "u1", "name": "Miles Esther", "avatar": "https://i.pravatar.cc/150?u=miles" },
          { "id": "u2", "name": "Thomas stieve", "avatar": "https://i.pravatar.cc/150?u=thomas" }
        ],
        "following": [
          { "id": "u1", "name": "Miles Esther", "avatar": "https://i.pravatar.cc/150?u=miles", "isOnline": true },
          { "id": "u3", "name": "Sarah Jenkins", "avatar": "https://i.pravatar.cc/150?u=sarah_j", "isOnline": true }
        ]
      };

      _friends = List<Map<String, dynamic>>.from(rawSocial['friends']);
      _friendRequests = List<Map<String, dynamic>>.from(rawSocial['requests']);
      _followers = List<Map<String, dynamic>>.from(rawSocial['followers']);
      _following = List<Map<String, dynamic>>.from(rawSocial['following']);
    } catch (e) {
      showErrorSnackBar(message: "Failed to fetch friends list: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchDiscoverSuggestions({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final Map<String, dynamic> rawSuggestions = {
        "suggestions": [
          { "id": "u567", "name": "Mike Lee", "avatar": "https://i.pravatar.cc/150?u=mike_l", "mutualFriends": 2 },
          { "id": "u568", "name": "Jordan K.", "avatar": "https://i.pravatar.cc/150?u=jordan", "mutualFriends": 3 },
          { "id": "u569", "name": "Maya J.", "avatar": "https://i.pravatar.cc/150?u=maya", "mutualFriends": 1 }
        ]
      };

      _discoverSuggestions = (rawSuggestions['suggestions'] as List).map((x) => SuggestionModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to fetch discover suggestions: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserProfile(String userId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
      _selectedUserProfile = null; // Clear previous state to show loading
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final Map<String, dynamic> rawProfile = {
        "status": "success",
        "data": {
          "user": {
            "id": userId,
            "name": userId == "u1" ? "Miles Esther" : (userId == "u2" ? "Thomas stieve" : "Mike Tyson"),
            "avatar": "https://i.pravatar.cc/150?u=$userId",
            "bio": "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon.",
            "stats": {
              "posts": 7,
              "friends": 128,
              "followers": 220,
              "following": 14
            },
            "relationshipStatus": userId == "req1" || userId == "req2" ? "request_received" : "none",
            "media": [
              "https://picsum.photos/300/300?random=1",
              "https://picsum.photos/300/300?random=2",
              "https://picsum.photos/300/300?random=3",
              "https://picsum.photos/300/300?random=4",
              "https://picsum.photos/300/300?random=5"
            ]
          }
        }
      };

      final data = rawProfile['data'] as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>;
      
      // Load standard dummy posts for the user profile
      user['posts'] = CirclePostModel.dummyPosts.map((p) => p.toJson()).toList();

      _selectedUserProfile = UserProfileModel.fromJson(user);
    } catch (e) {
      showErrorSnackBar(message: "Failed to load user profile: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> updateRelationshipStatus(String userId, String newStatus) async {
    if (_selectedUserProfile != null && _selectedUserProfile!.id == userId) {
      _selectedUserProfile = _selectedUserProfile!.copyWith(relationshipStatus: newStatus);
      notifyListeners();
    }
  }
}
