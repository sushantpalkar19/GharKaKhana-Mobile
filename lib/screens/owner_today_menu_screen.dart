import 'package:flutter/material.dart';
import '../core/theme.dart';

class OwnerTodayMenuScreen extends StatelessWidget {
  const OwnerTodayMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final todayMenu = {
      'Breakfast': ['Aloo Paratha (2 Pcs)', 'Fresh Curd', 'Green Chutney'],
      'Lunch': ['Paneer Butter Masala', 'Dal Makhani', '4 Ghee Rotis', 'Jeera Rice'],
      'Dinner': ['Aloo Gobi Matar', 'Yellow Dal Tadka', '4 Tawa Rotis', 'Steam Rice'],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Add food item
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: todayMenu.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (ctx, i) {
          final mealType = todayMenu.keys.elementAt(i);
          final items = todayMenu[mealType] as List<String>;
          return _buildMealSection(ctx, mealType, items);
        },
      ),
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    String mealType,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getMealIcon(mealType),
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              mealType,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '${items.length} items',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildMenuItem(item, index);
        }),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Add Food',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () {
              // TODO: Edit item
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              // TODO: Remove item
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.free_breakfast;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }
}
