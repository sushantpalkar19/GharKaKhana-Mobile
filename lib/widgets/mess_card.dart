import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/mess.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/helpers.dart';
import '../utils/snackbar.dart';

class MessCard extends StatelessWidget {
  final Mess mess;
  final VoidCallback? onTap;

  const MessCard({super.key, required this.mess, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () => Navigator.pushNamed(context, '/mess-detail', arguments: mess.id ?? ''),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: mess.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      placeholder: (context, url) => Container(
                        color: AppColors.border,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.border,
                        child: const Icon(Icons.restaurant_menu, size: 60, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  if ((mess.tags).isNotEmpty)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: mess.tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<UserProvider>(
                      builder: (ctx, userProv, _) {
                        final bookmarked = userProv.isBookmarked(mess.id ?? '');
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                          ),
                          child: IconButton(
                            icon: Icon(
                              bookmarked ? Icons.favorite : Icons.favorite_border,
                              color: bookmarked ? AppColors.primary : AppColors.textSecondary,
                              size: 22,
                            ),
                            onPressed: () async {
                              final auth = context.read<AuthProvider>();
                              final token = auth.token;
                              if (token == null) {
                                showSnackbar(ctx, 'Login to save messes');
                                return;
                              }
                              await userProv.toggleBookmark(token, mess.id!, mess);
                              showSnackbar(ctx, bookmarked ? 'Removed from saved' : 'Saved to bookmarks');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mess.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              mess.tagline,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    truncate(mess.address, 25),
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  mess.distance,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: i < mess.rating.floor()
                                ? AppColors.primary
                                : (i < mess.rating && i < mess.rating.ceil() ? AppColors.primary : AppColors.border),
                          );
                        }),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        mess.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        ' (${mess.totalReviews})',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Hygiene ${mess.hygieneScore}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: formatRupee(mess.priceStartingAt),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const TextSpan(
                              text: '/mo',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
