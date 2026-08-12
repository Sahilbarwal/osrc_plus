import 'package:flutter/material.dart';
import 'package:osrc_plus/services/worker_data.dart';

class SalaryScreen extends StatelessWidget {
  final String workerName;
  final double dailyRate;

  const SalaryScreen({
    super.key,
    required this.workerName,
    this.dailyRate = 500.0,
  });

  @override
  Widget build(BuildContext context) {
    final presentDays = WorkerData.getPresentDays(workerName);
    final totalAdvance = WorkerData.getTotalAdvance(workerName);
    final total = presentDays * dailyRate;
    final net = total - totalAdvance > 0 ? total - totalAdvance : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: Text("Salary - $workerName"),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _row("Present Days", presentDays.toString()),
            _row("Daily Rate", "₹${dailyRate.toStringAsFixed(2)}"),
            _row("Total Salary", "₹${total.toStringAsFixed(2)}"),
            _row("Total Advance", "₹${totalAdvance.toStringAsFixed(2)}"),
            const Divider(color: Colors.white),
            _row("Net Pay", "₹${net.toStringAsFixed(2)}", bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}