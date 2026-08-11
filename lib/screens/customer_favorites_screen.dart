import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/mess.dart';
import '../providers/mess_provider.dart';
import '../widgets/mess_card.dart';
import 'mess_detail_screen.dart';

class CustomerFavoritesScreen extends StatefulWidget {
  const CustomerFavoritesScreen({super.key});

  @override
  State<CustomerFavoritesScreen> createState() => _CustomerFavoritesScreenState();
}

class _CustomerFavoritesScreenState extends State<CustomerFavoritesScreen> {
  // TODO: Replace with real favorites from backend
  final List<String> _favoriteMessIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: Consumer<MessProvider>(
        builder: (_, messProv, __) {
          final favoriteMesses = messProv.messes
              .where((m) => _favoriteMessIds.contains(m.id))
              .toList();

          if (favoriteMesses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save messes you love for quick access',
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
            itemCount: favoriteMesses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => _buildFavoriteCard(favoriteMesses[i]),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(Mess mess) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/mess-detail', arguments: mess),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Mess Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                mess.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.surface,
                  child: Icon(Icons.restaurant, color: AppColors.textMuted),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mess.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          mess.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${mess.totalReviews})',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mess.distance,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${mess.priceStartingAt} onwards',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.favorite, color: AppColors.error, size: 20),
                          onPressed: () {
                            // TODO: Remove from favorites
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
