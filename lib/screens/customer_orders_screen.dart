import 'package:flutter/material.dart';
import '../core/theme.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ActiveOrdersTab(),
          _CompletedOrdersTab(),
          _CancelledOrdersTab(),
        ],
      ),
    );
  }
}

class _ActiveOrdersTab extends StatelessWidget {
  const _ActiveOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final activeOrders = [
      {
        'id': 'GK1024',
        'mess': 'Maa\'s Kitchen',
        'items': 'Veg Thali × 2',
        'amount': 160,
        'status': 'Preparing',
        'time': '25 min',
      },
      {
        'id': 'GK1023',
        'mess': 'Annapurna Home Mess',
        'items': 'Dal Rice × 1',
        'amount': 50,
        'status': 'Out for Delivery',
        'time': '10 min',
      },
    ];

    if (activeOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'No active orders',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order delicious food from nearby messes',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activeOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final order = activeOrders[i];
        return _buildOrderCard(context, order, true);
      },
    );
  }
}

class _CompletedOrdersTab extends StatelessWidget {
  const _CompletedOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final completedOrders = [
      {
        'id': 'GK1022',
        'mess': 'Sharma Ji Ki Rasoi',
        'items': 'Paneer Thali × 1',
        'amount': 120,
        'date': 'Yesterday',
        'rating': 5,
      },
      {
        'id': 'GK1021',
        'mess': 'Maa\'s Kitchen',
        'items': 'Veg Thali × 1',
        'amount': 80,
        'date': '2 days ago',
        'rating': 4,
      },
    ];

    if (completedOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'No completed orders',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: completedOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final order = completedOrders[i];
        return _buildOrderCard(context, order, false);
      },
    );
  }
}

class _CancelledOrdersTab extends StatelessWidget {
  const _CancelledOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final cancelledOrders = <Map<String, dynamic>>[];

    if (cancelledOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'No cancelled orders',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cancelledOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final order = cancelledOrders[i];
        return _buildOrderCard(context, order, false);
      },
    );
  }
}

Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order, bool isActive) {
  final status = order['status'] as String?;
  final statusColor = _getStatusColor(status);

  return Container(
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border, width: 0.5),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '#${order['id']}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (status == 'Preparing') ...[
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        status ?? '',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  order['date'] as String? ?? '',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order['mess'] as String? ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order['items'] as String? ?? '',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '₹${order['amount']}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (isActive)
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${order['time']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: List.generate(5, (index) {
                    final rating = order['rating'] as int? ?? 0;
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: AppColors.accent,
                    );
                  }),
                ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to order tracking screen
                },
                child: const Text('Track Order'),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

Color _getStatusColor(String? status) {
  switch (status) {
    case 'Preparing':
      return AppColors.primary;
    case 'Out for Delivery':
      return AppColors.secondary;
    case 'Delivered':
      return AppColors.success;
    case 'Cancelled':
      return AppColors.error;
    default:
      return AppColors.textSecondary;
  }
}
