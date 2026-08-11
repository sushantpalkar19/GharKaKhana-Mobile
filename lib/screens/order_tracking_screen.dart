import 'package:flutter/material.dart';
import '../core/theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final String messName;
  final int amount;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.messName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real order data from backend
    final currentStatus = 'Preparing';
    final statusSteps = [
      {'title': 'Order Placed', 'completed': true},
      {'title': 'Order Accepted', 'completed': true},
      {'title': 'Preparing Your Food', 'completed': true, 'current': true},
      {'title': 'Ready', 'completed': false},
      {'title': 'Delivered', 'completed': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Order #$orderId',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              currentStatus,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    messName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹$amount',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tracking Timeline
            Text(
              'Order Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            ...statusSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = step['completed'] as bool;
              final isCurrent = step['current'] as bool? ?? false;
              final isLast = index == statusSteps.length - 1;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.success
                              : isCurrent
                                  ? AppColors.primary
                                  : AppColors.border,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : (isCurrent ? Icons.restaurant : null),
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Status Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'] as String,
                              style: TextStyle(
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                color: isCompleted
                                    ? AppColors.textPrimary
                                    : isCurrent
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Estimated time: 15-20 min',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        height: 24,
                        width: 2,
                        color: isCompleted ? AppColors.success : AppColors.border,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            }),
            const SizedBox(height: 32),

            // Delivery Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delivery_dining, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Partner',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Will be assigned soon',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Help Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.support_agent, color: AppColors.accent),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Contact support for any issues',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
