import 'package:flutter/material.dart';
import 'package:osrc_plus/constants/constants.dart';

/// A reusable primary button with consistent styling across the app.
/// Uses the app's green secondary color with proper spacing and loading states.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = AppSpacing.buttonHeightMd,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.secondary,
          foregroundColor: textColor ?? AppColors.textPrimary,
          elevation: 2,
          shadowColor: (backgroundColor ?? AppColors.secondary).withOpacity(
            0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          disabledBackgroundColor: (backgroundColor ?? AppColors.secondary)
              .withOpacity(0.6),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: AppSpacing.iconMd,
                width: AppSpacing.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.textPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: textColor ?? AppColors.textPrimary,
                      size: AppSpacing.iconMd,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? AppColors.textPrimary,
                      fontSize: AppSpacing.fontSizeMd,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
