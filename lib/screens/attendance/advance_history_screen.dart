import 'package:flutter/material.dart';
import 'package:osrc_plus/services/worker_data.dart';

class AdvanceHistoryScreen extends StatelessWidget {
  final String workerName;
  const AdvanceHistoryScreen({super.key, required this.workerName});

  @override
  Widget build(BuildContext context) {
    final advances = WorkerData.getAdvanceHistory(workerName);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: Text("Advance History - $workerName"),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: advances.isEmpty
          ? const Center(
              child: Text("No advance given", style: TextStyle(color: Colors.white)),
            )
          : ListView.builder(
              itemCount: advances.length,
              itemBuilder: (context, index) {
                final record = advances[index];
                final amount = record['amount'] as double;
                final dateStr = record['date'] as String;
                final note = record['note'] as String?;
                final formattedDate = dateStr.split('T')[0];

                return Card(
                  color: const Color(0xFF1F1F1F),
                  child: ListTile(
                    leading: const Icon(Icons.money, color: Color(0xFFD4AF37)),
                    title: Text(
                      "₹${amount.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formattedDate, style: const TextStyle(color: Colors.grey)),
                        if (note != null)
                          Text("Note: $note", style: const TextStyle(color: Colors.orange, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}