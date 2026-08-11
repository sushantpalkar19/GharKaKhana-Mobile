import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final todayOrders = 24;
    final todayRevenue = 2450;
    final pendingOrders = 8;
    final activeCustomers = 18;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<AuthProvider>(
                  builder: (_, auth, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()} 👋',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's your mess overview for today.",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Metrics Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Today\'s Orders',
                        todayOrders.toString(),
                        Icons.shopping_bag_outlined,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Today\'s Revenue',
                        '₹$todayRevenue',
                        Icons.currency_rupee_outlined,
                        AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Pending Orders',
                        pendingOrders.toString(),
                        Icons.pending_outlined,
                        AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        'Active Customers',
                        activeCustomers.toString(),
                        Icons.people_outline,
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Pending Orders Alert
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.priority_high, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$pendingOrders orders pending',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Accept orders to start preparing',
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
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildQuickAction(
                      context,
                      'View Orders',
                      Icons.list_alt,
                      AppColors.primary,
                      () {
                        // TODO: Navigate to orders screen
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildQuickAction(
                      context,
                      'Manage Menu',
                      Icons.restaurant_menu,
                      AppColors.secondary,
                      () {
                        // TODO: Navigate to menu screen
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildQuickAction(
                      context,
                      'Today\'s Menu',
                      Icons.today,
                      AppColors.accent,
                      () {
                        // TODO: Navigate to today's menu screen
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
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

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
