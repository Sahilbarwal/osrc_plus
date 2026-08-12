import 'package:flutter/material.dart';
import 'package:osrc_plus/screens/worker/add_worker.dart';
import 'package:osrc_plus/screens/site/add_site.dart';
import 'package:osrc_plus/screens/attendance/attendance_screen.dart';
import 'package:osrc_plus/screens/salary/salary_report_screen.dart';
import 'package:osrc_plus/services/auth_service.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              AuthService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildCard(
              context,
              Icons.people,
              "Add Worker",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddWorkerScreen(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              Icons.location_city,
              "Add Site",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddSiteScreen(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              Icons.check_circle,
              "Mark Attendance",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AttendanceScreen(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              Icons.attach_money,
              "Salary Report",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SalaryReportScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: const Color(0xFF1F1F1F),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: const Color(0xFFD4AF37)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}