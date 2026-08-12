import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Utility class for saving files locally to device storage.
class StorageHelper {
  static const String _folderName = 'attendance_images';

  /// Gets the application documents directory.
  static Future<Directory> _getAppDocumentsDir() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Gets or creates the attendance images folder.
  static Future<Directory> _getAttendanceFolder() async {
    final appDocDir = await _getAppDocumentsDir();
    final attendanceDir = Directory(path.join(appDocDir.path, _folderName));

    // Create folder if it doesn't exist
    if (!await attendanceDir.exists()) {
      await attendanceDir.create(recursive: true);
    }

    return attendanceDir;
  }

  /// Saves an image file with a unique timestamp-based name.
  ///
  /// Copies the file from [sourceFilePath] to the attendance images folder
  /// with a unique filename based on current timestamp.
  ///
  /// Returns the path of the saved file, or null if save fails.
  static Future<String?> saveAttendanceImage(String sourceFilePath) async {
    try {
      final sourceFile = File(sourceFilePath);

      if (!await sourceFile.exists()) {
        debugPrint('Source file does not exist: $sourceFilePath');
        return null;
      }

      final attendanceDir = await _getAttendanceFolder();
      final fileName =
          'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final destinationPath = path.join(attendanceDir.path, fileName);

      // Copy file to new location
      final savedFile = await sourceFile.copy(destinationPath);

      return savedFile.path;
    } catch (e) {
      debugPrint('Error saving attendance image: $e');
      return null;
    }
  }

  /// Gets all saved attendance images.
  ///
  /// Returns a list of File objects in the attendance images folder.
  static Future<List<File>> getAttendanceImages() async {
    try {
      final attendanceDir = await _getAttendanceFolder();
      final files = attendanceDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.png'))
          .toList();

      return files..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    } catch (e) {
      debugPrint('Error getting attendance images: $e');
      return [];
    }
  }

  /// Deletes a saved attendance image.
  ///
  /// Returns true if deletion was successful, false otherwise.
  static Future<bool> deleteAttendanceImage(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error deleting attendance image: $e');
      return false;
    }
  }

  /// Gets the total size of all attendance images in bytes.
  static Future<int> getAttendanceImagesFolderSize() async {
    try {
      final images = await getAttendanceImages();
      int totalSize = 0;

      for (final file in images) {
        totalSize += await file.length();
      }

      return totalSize;
    } catch (e) {
      debugPrint('Error calculating folder size: $e');
      return 0;
    }
  }

  /// Clears all attendance images.
  ///
  /// Deletes all files in the attendance images folder.
  /// Returns true if successful.
  static Future<bool> clearAllAttendanceImages() async {
    try {
      final images = await getAttendanceImages();

      for (final file in images) {
        await file.delete();
      }

      return true;
    } catch (e) {
      debugPrint('Error clearing attendance images: $e');
      return false;
    }
  }
}

