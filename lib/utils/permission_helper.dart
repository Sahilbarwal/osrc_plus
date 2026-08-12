import 'package:permission_handler/permission_handler.dart';

/// Utility class for handling app permissions.
class PermissionHelper {
  /// Requests camera permission from the user.
  /// 
  /// Returns true if permission is granted, false otherwise.
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    
    return status.isGranted;
  }

  /// Checks if camera permission is already granted without requesting.
  /// 
  /// Returns true if permission is granted.
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    
    return status.isGranted;
  }

  /// Opens app settings if user denied permission permanently.
  static Future<void> openAppSettings() async {
    openAppSettings();
  }
}
