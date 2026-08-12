import 'package:osrc_plus/models/salary_model.dart';
import 'package:osrc_plus/services/worker_data.dart';

class SalaryService {
  // TODO: Replace this with Firestore collection 'salaries'.
  static final List<SalaryModel> _salaryRecords = [];

  /// Count the effective attendance days between range (inclusive).
  /// present = 1.0 day, half = 0.5 day.
  static Future<double> countAttendanceDays({
    required String workerId,
    DateTime? from,
    DateTime? to,
  }) async {
    final now = DateTime.now();
    final start = from ?? DateTime(now.year, now.month, 1);
    final end = to ?? DateTime(now.year, now.month + 1, 0);

    final attendance = WorkerData.getAttendanceDays(workerId, start, end);
    final present = attendance['present'] ?? 0;
    final half = attendance['half'] ?? 0;

    return present + (half * 0.5);
  }

  /// Generate month key for salary report using year-month.
  static String _salaryId(String workerId, int year, int month) => '$workerId-$year-${month.toString().padLeft(2, '0')}';

  /// Generate and store monthly salary report.
  static Future<SalaryModel> generateMonthlySalaryReport({
    required String workerId,
    required double salaryPerDay,
    required int year,
    required int month,
  }) async {
    final fromDate = DateTime(year, month, 1);
    final toDate = DateTime(year, month + 1, 0);
    final effectiveDays = await countAttendanceDays(workerId: workerId, from: fromDate, to: toDate);
    final totalSalary = effectiveDays * salaryPerDay;

    final report = SalaryModel(
      id: _salaryId(workerId, year, month),
      userId: workerId,
      month: '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}',
      totalDays: effectiveDays.round(),
      totalSalary: double.parse(totalSalary.toStringAsFixed(2)),
      paid: false,
    );

    _salaryRecords.removeWhere((item) => item.id == report.id);
    _salaryRecords.add(report);
    return report;
  }

  /// Fetch all salary reports. Optionally filter by worker or month.
  static Future<List<SalaryModel>> getSalaryRecords({
    String? workerId,
    String? month,
  }) async {
    var items = _salaryRecords;
    if (workerId != null) {
      items = items.where((r) => r.userId == workerId).toList();
    }
    if (month != null) {
      items = items.where((r) => r.month == month).toList();
    }
    return List.from(items);
  }

  static Future<SalaryModel?> getSalaryReportByWorkerAndMonth({
    required String workerId,
    required int year,
    required int month,
  }) async {
    final id = _salaryId(workerId, year, month);
    try {
      return _salaryRecords.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}

