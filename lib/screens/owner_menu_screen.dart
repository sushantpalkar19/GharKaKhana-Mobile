import 'package:flutter/material.dart';
import '../core/theme.dart';

class OwnerMenuScreen extends StatefulWidget {
  const OwnerMenuScreen({super.key});

  @override
  State<OwnerMenuScreen> createState() => _OwnerMenuScreenState();
}

class _OwnerMenuScreenState extends State<OwnerMenuScreen> {
  // TODO: Replace with real menu data from backend
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': '1',
      'name': 'Veg Thali',
      'price': 80,
      'available': true,
      'category': 'Thali',
    },
    {
      'id': '2',
      'name': 'Paneer Thali',
      'price': 120,
      'available': true,
      'category': 'Thali',
    },
    {
      'id': '3',
      'name': 'Dal Rice',
      'price': 50,
      'available': true,
      'category': 'Meals',
    },
    {
      'id': '4',
      'name': 'Curry Rice',
      'price': 60,
      'available': false,
      'category': 'Meals',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Show add item dialog
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) => _buildMenuItemCard(_menuItems[i]),
      ),
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item) {
    final isAvailable = item['available'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String? ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['category'] as String? ?? '',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${item['price']}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isAvailable ? Icons.circle : Icons.circle_outlined,
                        size: 6,
                        color: isAvailable ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isAvailable ? 'Available' : 'Disabled',
                        style: TextStyle(
                          color: isAvailable ? AppColors.success : AppColors.error,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () {
                        // TODO: Edit item
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isAvailable ? Icons.toggle_on : Icons.toggle_off,
                        color: isAvailable ? AppColors.success : AppColors.error,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          item['available'] = !isAvailable;
                        });
                        // TODO: Update availability on backend
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
