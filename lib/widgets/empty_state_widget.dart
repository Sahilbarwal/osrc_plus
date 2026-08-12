import 'package:flutter/material.dart';
import 'package:osrc_plus/constants/constants.dart';
import 'package:osrc_plus/widgets/primary_button.dart';

/// A reusable empty state widget for when there's no data to display.
/// Features consistent styling with an icon and message.
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? iconSize;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    this.message = 'No data available',
    this.icon = Icons.inbox,
    this.actionText,
    this.onActionPressed,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.secondary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize ?? AppSpacing.iconXl,
                color: iconColor ?? AppColors.secondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSpacing.fontSizeMd,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: actionText!,
                onPressed: onActionPressed,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}