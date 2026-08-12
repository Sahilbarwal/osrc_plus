import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:osrc_plus/services/salary_service.dart';
import 'package:osrc_plus/services/worker_data.dart';
import 'package:osrc_plus/widgets/widgets.dart';



class SalaryReportScreen extends StatefulWidget {
  const SalaryReportScreen({super.key});

  @override
  State<SalaryReportScreen> createState() => _SalaryReportScreenState();
}

class _SalaryReportScreenState extends State<SalaryReportScreen> {
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  List<Map<String, dynamic>> _reports = [];

  @override
  void initState() {
    super.initState();
    _generateMonthlyReport();
  }

  Future<void> _generateMonthlyReport() async {
    final reports = <Map<String, dynamic>>[];
    for (final worker in WorkerData.workers) {
      final report = await SalaryService.generateMonthlySalaryReport(
        workerId: worker.id,
        salaryPerDay: worker.salaryPerDay,
        year: _selectedYear,
        month: _selectedMonth,
      );
      reports.add({
        'name': worker.name,
        'daysWorked': report.totalDays,
        'totalSalary': report.totalSalary,
      });
    }
    setState(() => _reports = reports);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text('Monthly Salary Report'),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Month/Year Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: _selectedMonth,
                  dropdownColor: const Color(0xFF1F1F1F),
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text(
                        DateFormat('MMMM').format(DateTime(0, month)),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedMonth = value);
                      _generateMonthlyReport();
                    }
                  },
                ),
                const SizedBox(width: 20),
                DropdownButton<int>(
                  value: _selectedYear,
                  dropdownColor: const Color(0xFF1F1F1F),
                  items: List.generate(5, (index) {
                    final year = DateTime.now().year - 2 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedYear = value);
                      _generateMonthlyReport();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Salary Reports',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _reports.isEmpty
                  ? const EmptyStateWidget(
                      message: 'No workers or no attendance data for the selected month.',
                      icon: Icons.attach_money,
                    )
                  : ListView.builder(
                      itemCount: _reports.length,
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        return Card(
                          color: const Color(0xFF1F1F1F),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              report['name'],
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            subtitle: Text(
                              'Days Worked: ${report['daysWorked']} • Total Salary: \$${report['totalSalary'].toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            leading: const Icon(
                              Icons.attach_money,
                              color: Color(0xFFD4AF37),
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}