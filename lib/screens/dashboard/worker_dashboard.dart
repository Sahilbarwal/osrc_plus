import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osrc_plus/providers/auth_provider.dart';
import 'package:osrc_plus/screens/attendance/mark_worker_attendance.dart';
import 'package:osrc_plus/services/worker_data.dart';
import 'package:osrc_plus/widgets/widgets.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final name = user?.name ?? 'Unknown';
    final history = WorkerData.getAttendanceRecordsForUser(name);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large Mark Attendance Button
            PrimaryButton(
              text: 'Mark Attendance',
              icon: Icons.check_circle,
              height: 120,
              onPressed: () {
                final user = authProvider.user;
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MarkWorkerAttendance(workerName: user.name),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'History',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        'No history yet',
                        style: TextStyle(color: Colors.white60, fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final record = history[index];
                        return Card(
                          color: const Color(0xFF1F1F1F),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(
                              '${record['date']} at ${record['time']}',
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            subtitle: Text(
                              'Status: ${record['status']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            leading: Icon(
                              record['status'] == 'Present' ? Icons.check_circle : Icons.cancel,
                              color: record['status'] == 'Present' ? Colors.green : Colors.red,
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
