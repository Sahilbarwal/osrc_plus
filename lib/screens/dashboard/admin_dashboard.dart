import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osrc_plus/providers/auth_provider.dart';
import 'package:osrc_plus/screens/attendance/attendance_screen.dart';
import 'package:osrc_plus/screens/site/add_site.dart';
import 'package:osrc_plus/screens/worker/add_worker.dart';
import 'package:osrc_plus/screens/salary/salary_report_screen.dart';
import 'package:osrc_plus/widgets/widgets.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  CardTile(
                    icon: Icons.check_circle,
                    title: 'Attendance',
                    height: 120,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
                    },
                  ),
                  CardTile(
                    icon: Icons.location_city,
                    title: 'Sites',
                    height: 120,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSiteScreen()));
                    },
                  ),
                  CardTile(
                    icon: Icons.people,
                    title: 'Workers',
                    height: 120,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddWorkerScreen()));
                    },
                  ),
                  CardTile(
                    icon: Icons.attach_money,
                    title: 'Salary',
                    height: 120,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaryReportScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
