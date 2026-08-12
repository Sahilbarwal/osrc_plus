import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osrc_plus/constants/constants.dart';
import 'package:osrc_plus/providers/auth_provider.dart';
import 'package:osrc_plus/screens/auth/register_screen.dart';
import 'package:osrc_plus/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(_emailController.text.trim(), _password.text);

      setState(() => _loading = false);

      if (success) {
        final role = authProvider.user?.role;
        if (role == 'admin') {
          Navigator.pushNamedAndRemoveUntil(context, '/dashboardAdmin', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/dashboardWorker', (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.xl),
                      ),
                      child: Icon(
                        Icons.business,
                        size: AppSpacing.iconXl * 2,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Title
                    Text(
                      "Welcome Back",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      "Sign in to your account",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: "Email Address",
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "Please enter your email";
                        if (!RegExp(r"^[^@]+@[^@]+\.[^@]+$").hasMatch(v.trim())) return "Please enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password Field
                    CustomTextField(
                      controller: _password,
                      labelText: "Password",
                      hintText: "Enter your password",
                      obscureText: true,
                      validator: (v) => v!.isEmpty ? "Please enter your password" : null,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Login Button
                    PrimaryButton(
                      text: "Sign In",
                      icon: Icons.login,
                      isLoading: _loading,
                      onPressed: _login,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                          ),
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}