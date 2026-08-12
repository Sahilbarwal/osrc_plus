import 'package:flutter/material.dart';
import 'package:osrc_plus/screens/attendance/mark_worker_attendance.dart';
import 'package:osrc_plus/services/worker_data.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text("Select Worker"),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: WorkerData.workers.isEmpty
          ? const Center(
              child: Text("No workers added", style: TextStyle(color: Colors.white)),
            )
          : ListView.builder(
              itemCount: WorkerData.workers.length,
              itemBuilder: (context, index) {
                final worker = WorkerData.workers[index];
                return ListTile(
                  title: Text(worker.name, style: const TextStyle(color: Colors.white)),
                  tileColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MarkWorkerAttendance(workerName: worker.name),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}