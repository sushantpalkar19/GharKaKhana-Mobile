import 'package:flutter/material.dart';
import '../core/theme.dart';

class OwnerReviewsScreen extends StatelessWidget {
  const OwnerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from backend
    final averageRating = 4.6;
    final totalReviews = 245;
    final reviews = [
      {
        'name': 'Sushant Palkar',
        'rating': 5,
        'comment': 'Food was fresh and tasty. The thali was exactly what I was looking for!',
        'date': '2 days ago',
      },
      {
        'name': 'Priya Sharma',
        'rating': 4,
        'comment': 'Good quantity and price. Delivery was on time.',
        'date': '3 days ago',
      },
      {
        'name': 'Rahul Kumar',
        'rating': 5,
        'comment': 'Best homemade food in the area. Highly recommended!',
        'date': '5 days ago',
      },
      {
        'name': 'Neha Gupta',
        'rating': 4,
        'comment': 'Consistent quality. Love the dal makhani!',
        'date': '1 week ago',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Overview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              averageRating.toString(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < averageRating.floor()
                                      ? Icons.star
                                      : index < averageRating
                                          ? Icons.star_half
                                          : Icons.star_border,
                                  color: AppColors.accent,
                                  size: 16,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$totalReviews Reviews',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildRatingBar(5, 0.7),
                            _buildRatingBar(4, 0.2),
                            _buildRatingBar(3, 0.05),
                            _buildRatingBar(2, 0.03),
                            _buildRatingBar(1, 0.02),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reviews List
            Text(
              'Recent Reviews',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...reviews.map((review) => _buildReviewCard(review)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = review['rating'] as int;
    final name = review['name'] as String;
    final comment = review['comment'] as String;
    final date = review['date'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: AppColors.accent,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
