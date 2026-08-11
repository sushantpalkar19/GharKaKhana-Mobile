import 'package:flutter/material.dart';
import '../core/theme.dart';

class OwnerOrdersScreen extends StatefulWidget {
  const OwnerOrdersScreen({super.key});

  @override
  State<OwnerOrdersScreen> createState() => _OwnerOrdersScreenState();
}

class _OwnerOrdersScreenState extends State<OwnerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Orders'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'NEW'),
            Tab(text: 'PREPARING'),
            Tab(text: 'READY'),
            Tab(text: 'COMPLETED'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _NewOrdersTab(),
          _PreparingOrdersTab(),
          _ReadyOrdersTab(),
          _CompletedOrdersTab(),
        ],
      ),
    );
  }
}

class _NewOrdersTab extends StatelessWidget {
  const _NewOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final newOrders = [
      {
        'id': 'GK1024',
        'customer': 'Sushant',
        'items': '2 × Veg Thali',
        'amount': 160,
        'time': '2 min ago',
      },
      {
        'id': 'GK1025',
        'customer': 'Rahul',
        'items': '1 × Paneer Thali',
        'amount': 120,
        'time': '5 min ago',
      },
    ];

    if (newOrders.isEmpty) {
      return _buildEmptyState('No new orders', 'Orders will appear here when customers place them');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: newOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildOrderCard(context, newOrders[i], 'new'),
    );
  }
}

class _PreparingOrdersTab extends StatelessWidget {
  const _PreparingOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final preparingOrders = [
      {
        'id': 'GK1023',
        'customer': 'Priya',
        'items': '1 × Dal Rice',
        'amount': 50,
        'time': 'Started 10 min ago',
      },
    ];

    if (preparingOrders.isEmpty) {
      return _buildEmptyState('No orders preparing', 'Accepted orders will appear here');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: preparingOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildOrderCard(context, preparingOrders[i], 'preparing'),
    );
  }
}

class _ReadyOrdersTab extends StatelessWidget {
  const _ReadyOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final readyOrders = [
      {
        'id': 'GK1022',
        'customer': 'Amit',
        'items': '1 × Veg Thali',
        'amount': 80,
        'time': 'Ready 5 min ago',
      },
    ];

    if (readyOrders.isEmpty) {
      return _buildEmptyState('No orders ready', 'Completed preparations will appear here');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: readyOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildOrderCard(context, readyOrders[i], 'ready'),
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
        'id': 'GK1021',
        'customer': 'Neha',
        'items': '2 × Dal Rice',
        'amount': 100,
        'time': 'Completed 15 min ago',
      },
      {
        'id': 'GK1020',
        'customer': 'Vikram',
        'items': '1 × Paneer Thali',
        'amount': 120,
        'time': 'Completed 30 min ago',
      },
    ];

    if (completedOrders.isEmpty) {
      return _buildEmptyState('No completed orders', 'Delivered orders will appear here');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: completedOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildOrderCard(context, completedOrders[i], 'completed'),
    );
  }
}

Widget _buildEmptyState(String title, String subtitle) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 64, color: AppColors.textMuted),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order, String status) {
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
              Text(
                order['time'] as String? ?? '',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order['customer'] as String? ?? '',
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
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              _buildActionButton(context, status, order['id'] as String? ?? ''),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildActionButton(BuildContext context, String status, String orderId) {
  switch (status) {
    case 'new':
      return SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Accept order
          },
          child: const Text('Accept'),
        ),
      );
    case 'preparing':
      return SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Mark as ready
          },
          child: const Text('Ready'),
        ),
      );
    case 'ready':
      return SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Complete order
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
          ),
          child: const Text('Complete'),
        ),
      );
    case 'completed':
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 16),
            const SizedBox(width: 4),
            Text(
              'Delivered',
              style: TextStyle(
                color: AppColors.success,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    default:
      return const SizedBox();
  }
}
