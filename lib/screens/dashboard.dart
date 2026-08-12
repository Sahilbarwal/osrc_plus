import 'package:flutter/material.dart';
import 'package:osrc_plus/constants/constants.dart';
// import 'package:osrc_plus/screens/add_worker.dart';
// import 'package:osrc_plus/screens/add_site.dart';
// import 'package:osrc_plus/screens/attendance_screen.dart';
// import 'package:osrc_plus/screens/salary_report_screen.dart';
import 'package:osrc_plus/services/auth_service.dart';
import 'package:osrc_plus/widgets/widgets.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              AuthService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: AppSpacing.xl,
                      color: Colors.white,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Admin",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            "Manage your workforce efficiently",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Menu Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  children: [
                    // CardTile(
                    //   icon: Icons.people,
                    //   title: "Add Worker",
                    //   subtitle: "Register new employees",
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const AddWorkerScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // CardTile(
                    //   icon: Icons.location_city,
                    //   title: "Add Site",
                    //   subtitle: "Create work locations",
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const AddSiteScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // CardTile(
                    //   icon: Icons.check_circle,
                    //   title: "Mark Attendance",
                    //   subtitle: "Track daily attendance",
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const AttendanceScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // CardTile(
                    //   icon: Icons.attach_money,
                    //   title: "Salary Report",
                    //   subtitle: "View payment reports",
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const SalaryReportScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}