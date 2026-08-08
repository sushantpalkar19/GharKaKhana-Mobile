import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/mess.dart';
import '../utils/helpers.dart';

class PlanCard extends StatelessWidget {
  final MessPlan plan;
  final bool selected;
  final VoidCallback? onSelect;

  const PlanCard({super.key, required this.plan, this.selected = false, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (plan.popular)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: AppColors.primary,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    label: const Text(
                      'POPULAR',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  formatRupee(plan.price),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  formatRupee(plan.originalPrice),
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Save ${formatRupee(plan.originalPrice - plan.price)}',
                  style: const TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${plan.duration}  •  ${plan.deliveriesPerDay} deliveries/day  •  ${plan.includesSundaySpecial ? "Includes Sunday Special" : "Weekdays only"}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              runSpacing: 6,
              spacing: 8,
              children: plan.features.map((f) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.secondary, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        f,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
