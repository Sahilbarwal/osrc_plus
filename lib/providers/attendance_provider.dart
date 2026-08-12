import 'package:flutter/foundation.dart';
import 'package:osrc_plus/services/worker_data.dart';

class AttendanceProvider extends ChangeNotifier {
  void markAttendance(String workerName, String date, String status) {
    WorkerData.markAttendance(workerName, date, status);
    notifyListeners();
  }

  Map<String, String> attendanceForWorker(String workerName) {
    return WorkerData.getAttendanceMapForUser(workerName);
  }

  Map<String, int> attendanceDays(String workerName, DateTime from, DateTime to) {
    return WorkerData.getAttendanceDays(workerName, from, to);
  }
}
