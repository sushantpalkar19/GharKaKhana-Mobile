import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../utils/snackbar.dart';
import '../widgets/custom_button.dart';

class OwnerVerificationScreen extends StatelessWidget {
  const OwnerVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pending_actions,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'Home Mess Under Verification',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your home mess application is currently under review by our team.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.schedule,
                      label: 'Estimated Review Time',
                      value: '2-3 Business Days',
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.email,
                      label: 'Contact Support',
                      value: 'support@gharkakhana.com',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Consumer<AuthProvider>(
                builder: (ctx, auth, _) {
                  return CustomButton(
                    text: 'Logout',
                    color: Colors.red,
                    isOutlined: true,
                    onPressed: () async {
                      await auth.logout();
                      if (ctx.mounted) {
                        showSnackbar(ctx, 'Logged out successfully');
                        Navigator.pushNamedAndRemoveUntil(
                          ctx,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Open email client or support page
                  showSnackbar(context, 'Opening support...');
                },
                child: Text(
                  'Contact Support',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
