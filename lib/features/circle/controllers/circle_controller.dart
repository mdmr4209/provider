import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/helpers/snack_bar_helper.dart';
import '../models/circle_post_model.dart';

class CircleController extends ChangeNotifier {
  List<CirclePostModel> _posts = [];
  List<SuggestionModel> _members = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  List<CirclePostModel> get posts => _posts;
  List<SuggestionModel> get members => _members;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

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
}
