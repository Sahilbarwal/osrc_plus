import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osrc_plus/utils/permission_helper.dart';

/// Utility class for handling image capture and compression operations.
class ImageHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Captures an image from the device camera and compresses it.
  /// 
  /// Requests camera permission if not already granted.
  /// Returns a File object if successful, null if user cancels, permission denied, or error occurs.
  /// Compresses the image to 50% quality to reduce file size.
  static Future<File?> captureImageFromCamera() async {
    try {
      // Request camera permission
      final hasPermission = await PermissionHelper.requestCameraPermission();
      if (!hasPermission) {
        debugPrint('Camera permission denied');
        return null;
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      if (pickedFile == null) {
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    }
  }

  /// Selects an image from the device gallery and compresses it.
  /// 
  /// Requests storage permission if needed.
  /// Returns a File object if successful, null if user cancels or error occurs.
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile == null) {
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
}
