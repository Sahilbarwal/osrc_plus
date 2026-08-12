import 'package:hive/hive.dart';
import 'package:osrc_plus/models/attendance_hive_model.dart';

/// Service for managing attendance records in Hive local database.
/// 
/// Provides clean separation between UI and data persistence logic.
/// All attendance data is stored locally on the device using Hive.
class AttendanceService {
  static const String _boxName = 'attendanceBox';

  /// Get the attendance box
  static Box<AttendanceHiveModel> _getBox() {
    return Hive.box<AttendanceHiveModel>(_boxName);
  }

  /// Save an attendance record to Hive
  /// 
  /// Persists attendance data with name, date, time, and image path.
  /// Returns the key of the saved record.
  static Future<int> saveAttendance({
    required String name,
    required String date,
    required String time,
    required String imagePath,
  }) async {
    final record = AttendanceHiveModel(
      name: name,
      date: date,
      time: time,
      imagePath: imagePath,
    );

    return await _getBox().add(record);
  }

  /// Get all attendance records
  static List<AttendanceHiveModel> getAllAttendance() {
    return _getBox().values.toList();
  }

  /// Get attendance records for a specific worker
  static List<AttendanceHiveModel> getWorkerAttendance(String name) {
    return _getBox()
        .values
        .where((record) => record.name == name)
        .toList();
  }

  /// Get attendance records for a specific date
  static List<AttendanceHiveModel> getAttendanceByDate(String date) {
    return _getBox()
        .values
        .where((record) => record.date == date)
        .toList();
  }

  /// Get attendance records for a worker on a specific date
  static List<AttendanceHiveModel> getWorkerAttendanceOnDate(String name, String date) {
    return _getBox()
        .values
        .where((record) => record.name == name && record.date == date)
        .toList();
  }

  /// Delete an attendance record by key
  static Future<void> deleteAttendance(int key) async {
    await _getBox().delete(key);
  }

  /// Clear all attendance records
  static Future<void> clearAllAttendance() async {
    await _getBox().clear();
  }

  /// Get total count of attendance records
  static int getAttendanceCount() {
    return _getBox().length;
  }

  /// Get attendance count for a specific worker
  static int getWorkerAttendanceCount(String name) {
    return _getBox()
        .values
        .where((record) => record.name == name)
        .length;
  }
}
