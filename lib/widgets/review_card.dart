import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../models/mess.dart';

class ReviewCard extends StatelessWidget {
  final MessReview review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: CachedNetworkImageProvider(review.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        return Icon(
                          Icons.star,
                          size: 14,
                          color: i < review.rating ? AppColors.primary : AppColors.border,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  review.userRole,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                Text(
                  review.comment,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  review.date,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
