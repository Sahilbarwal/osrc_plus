import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:osrc_plus/constants/constants.dart';
import 'package:osrc_plus/models/attendance_hive_model.dart';
import 'package:osrc_plus/providers/auth_provider.dart';
import 'package:osrc_plus/providers/attendance_provider.dart';
import 'package:osrc_plus/providers/site_provider.dart';
import 'package:osrc_plus/providers/salary_provider.dart';
import 'package:osrc_plus/screens/auth/login_screen.dart';
import 'package:osrc_plus/screens/auth/register_screen.dart';
import 'package:osrc_plus/screens/dashboard/admin_dashboard.dart';
import 'package:osrc_plus/screens/dashboard/worker_dashboard.dart';

void main() async {
  try {
    // Ensure Flutter bindings are initialized first
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Hive with Flutter app directories
    await Hive.initFlutter();
    
    // Register all Hive adapters before opening boxes
    Hive.registerAdapter(AttendanceHiveModelAdapter());
    
    // Open attendance box for local storage
    await Hive.openBox<AttendanceHiveModel>('attendanceBox');
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
    // Continue with app even if Hive fails to initialize
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => SiteProvider()),
        ChangeNotifierProvider(create: (_) => SalaryProvider()),
      ],
      child: MaterialApp(
        title: 'Worker Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeXxl,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.textPrimary,
              elevation: 2,
              shadowColor: AppColors.secondary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              textStyle: const TextStyle(
                fontSize: AppSpacing.fontSizeMd,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: AppColors.cardBackground,
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            margin: const EdgeInsets.all(AppSpacing.sm),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.focus, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            labelStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSpacing.fontSizeMd,
            ),
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppSpacing.fontSizeMd,
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeXxxl,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeXxl,
              fontWeight: FontWeight.w600,
            ),
            displaySmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeXl,
              fontWeight: FontWeight.w600,
            ),
            headlineLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeXl,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeLg,
              fontWeight: FontWeight.w600,
            ),
            headlineSmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeMd,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeLg,
              fontWeight: FontWeight.w500,
            ),
            titleMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeMd,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeSm,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeMd,
              fontWeight: FontWeight.normal,
            ),
            bodyMedium: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSpacing.fontSizeMd,
              fontWeight: FontWeight.normal,
            ),
            bodySmall: TextStyle(
              color: AppColors.textMuted,
              fontSize: AppSpacing.fontSizeSm,
              fontWeight: FontWeight.normal,
            ),
            labelLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.fontSizeMd,
              fontWeight: FontWeight.w500,
            ),
            labelMedium: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSpacing.fontSizeSm,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              color: AppColors.textMuted,
              fontSize: AppSpacing.fontSizeXs,
              fontWeight: FontWeight.w500,
            ),
          ),
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            background: AppColors.background,
            error: AppColors.error,
            onPrimary: AppColors.textPrimary,
            onSecondary: AppColors.textPrimary,
            onSurface: AppColors.textPrimary,
            onBackground: AppColors.textPrimary,
            onError: AppColors.textPrimary,
          ),
        ),
        // Named routes for clean navigation
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboardAdmin': (context) => const AdminDashboard(),
          '/dashboardWorker': (context) => const WorkerDashboard(),
        },
      ),
    );
  }
}