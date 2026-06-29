import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class GroupPostController extends ChangeNotifier {
  final TextEditingController postTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _isAnonymous = false;
  final List<XFile> _selectedMedia = [];

  bool get isLoading => _isLoading;
  bool get isAnonymous => _isAnonymous;
  List<XFile> get selectedMedia => _selectedMedia;

  void toggleAnonymous(bool? value) {
    _isAnonymous = value ?? false;
    notifyListeners();
  }

  Future<void> pickMedia({bool isVideo = false}) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
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

  void removeMedia(int index) {
    _selectedMedia.removeAt(index);
    notifyListeners();
  }

  void clearState() {
    postTextController.clear();
    _selectedMedia.clear();
    _isAnonymous = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createGroupPost(String groupId) async {
    if (postTextController.text.trim().isEmpty && _selectedMedia.isEmpty) {
      showErrorSnackBar(message: "Please add some content or media.");
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      showSuccessSnackBar(message: "Post shared in group!");
      clearState();
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to post: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
