import 'package:flutter/material.dart';
import '../core/theme.dart';

class OwnerEarningsScreen extends StatelessWidget {
  const OwnerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final totalRevenue = 45280;
    final thisMonthRevenue = 18420;
    final totalOrders = 1248;
    final averageOrder = 86;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Revenue Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Revenue',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹$totalRevenue',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.white.withValues(alpha: 0.8), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '+12.5% from last month',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'This Month',
                    '₹$thisMonthRevenue',
                    Icons.calendar_today,
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Total Orders',
                    totalOrders.toString(),
                    Icons.shopping_bag,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Average Order',
                    '₹$averageOrder',
                    Icons.receipt_long,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Active Days',
                    '28',
                    Icons.event,
                    AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Transactions
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _buildTransactionItem('Order #GK1024', '₹160', 'Today, 2:30 PM'),
            _buildTransactionItem('Order #GK1023', '₹120', 'Today, 1:15 PM'),
            _buildTransactionItem('Order #GK1022', '₹80', 'Today, 12:45 PM'),
            _buildTransactionItem('Order #GK1021', '₹200', 'Yesterday, 8:00 PM'),
            _buildTransactionItem('Order #GK1020', '₹150', 'Yesterday, 7:30 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.arrow_downward, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
