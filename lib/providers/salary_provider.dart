import 'package:flutter/foundation.dart';
import 'package:osrc_plus/models/salary_model.dart';

class SalaryProvider extends ChangeNotifier {
  final List<SalaryModel> _salaryRecords = [];

  List<SalaryModel> get salaryRecords => List.unmodifiable(_salaryRecords);

  void addSalary(SalaryModel record) {
    _salaryRecords.add(record);
    notifyListeners();
  }

  void updateSalary(String id, SalaryModel updated) {
    final index = _salaryRecords.indexWhere((r) => r.id == id);
    if (index != -1) {
      _salaryRecords[index] = updated;
      notifyListeners();
    }
  }

  void setPaid(String id, bool paid) {
    final index = _salaryRecords.indexWhere((r) => r.id == id);
    if (index == -1) return;
    _salaryRecords[index] = _salaryRecords[index].copyWith(paid: paid);
    notifyListeners();
  }
}
