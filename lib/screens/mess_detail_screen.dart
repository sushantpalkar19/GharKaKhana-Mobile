import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../models/mess.dart';
import '../providers/auth_provider.dart';
import '../providers/mess_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/user_provider.dart';
import '../utils/helpers.dart';
import '../utils/snackbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/plan_card.dart';
import '../widgets/review_card.dart';

class MessDetailScreen extends StatefulWidget {
  const MessDetailScreen({super.key});

  @override
  State<MessDetailScreen> createState() => _MessDetailScreenState();
}

class _MessDetailScreenState extends State<MessDetailScreen> {
  MessPlan? _selectedPlan;
  String? _messId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messId = ModalRoute.of(context)?.settings.arguments as String?;
      if (_messId != null) {
        context.read<MessProvider>().fetchMessDetail(_messId!);
      }
    });
  }

  Future<void> _confirmSubscribe(Mess mess) async {
    if (_selectedPlan == null) {
      showSnackbar(context, 'Please select a plan first');
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Confirm Subscription', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mess.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(_selectedPlan!.name, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Total: ', style: TextStyle(fontSize: 14)),
                Text(formatRupee(_selectedPlan!.price), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          CustomButton(
            text: 'Pay & Subscribe',
            onPressed: () => Navigator.pop(ctx, true),
            width: 160,
            height: 44,
          ),
        ],
      ),
    );
    if (ok == true) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      final subProv = context.read<SubscriptionProvider>();
      final today = DateTime.now();
      final expiry = today.add(const Duration(days: 30));
      String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][d.month - 1]} ${d.year}';
      final result = await subProv.subscribe(
        auth.token ?? '',
        messId: mess.id ?? '',
        messName: mess.name,
        planName: _selectedPlan!.name,
        amountPaid: _selectedPlan!.price,
        startDate: fmt(today),
        expiryDate: fmt(expiry),
        mealTime: AppConstants.mealTimeLunchDinner,
      );
      if (!mounted) return;
      if (result != null) {
        showSnackbar(context, 'Subscribed successfully! 🎉');
        Navigator.pushReplacementNamed(context, '/subscriptions');
      } else {
        showSnackbar(context, 'Failed to subscribe. Please try again.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessProvider>(
      builder: (ctx, messProv, _) {
        final mess = messProv.selectedMess ?? Mess(
          id: '',
          name: '',
          tagline: '',
          address: '',
          distance: '',
          rating: 0,
          totalReviews: 0,
          hygieneScore: 0,
          priceStartingAt: 0,
          isVerified: false,
          image: '',
          bannerImage: '',
          ownerName: '',
          phone: '',
          timings: '',
        );
        return Scaffold(
          body: DefaultTabController(
            length: 3,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: mess.bannerImage,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Shimmer.fromColors(
                              baseColor: AppColors.border,
                              highlightColor: Colors.white,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (_, _, _) => Container(color: AppColors.border, child: const Icon(Icons.restaurant, size: 60, color: AppColors.textMuted)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black87, Colors.black.withOpacity(0.3), Colors.transparent],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mess.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${mess.cuisineType.join(" • ")} • ${mess.distance}',
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (i) {
                                return Icon(Icons.star, size: 16, color: i < mess.rating ? AppColors.primary : AppColors.border);
                              }),
                            ),
                            const SizedBox(width: 6),
                            Text(mess.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(' (${mess.totalReviews})', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(8)),
                              child: Text('Hygiene ${mess.hygieneScore}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                            ),
                            const SizedBox(width: 10),
                            if (mess.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.verified, color: AppColors.primary, size: 14),
                                  const SizedBox(width: 4),
                                  Text('Verified', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                                ]),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle('About the Mess'),
                        const SizedBox(height: 8),
                        Text(mess.tagline, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Expanded(child: Text(truncate(mess.address, 40), style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                            const SizedBox(width: 10),
                            Icon(Icons.phone, color: AppColors.primary, size: 18),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.schedule_outlined, size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Expanded(child: Text(mess.timings, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _sectionTitle("Today's Menu"),
                        const SizedBox(height: 12),
                        const TabBar(
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textMuted,
                          indicatorColor: AppColors.primary,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          tabs: [Tab(text: 'Breakfast'), Tab(text: 'Lunch'), Tab(text: 'Dinner')],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: TabBarView(
                            children: [
                              _menuList(Icons.breakfast_dining_outlined, mess.todayMenu.breakfast, '🥞'),
                              _menuList(Icons.lunch_dining_outlined, mess.todayMenu.lunch, '🍛'),
                              _menuList(Icons.dinner_dining_outlined, mess.todayMenu.dinner, '🍲'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _sectionTitle('Subscription Plans'),
                        const SizedBox(height: 12),
                        ...mess.plans.asMap().entries.map((e) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: e.key == mess.plans.length - 1 ? 0 : 12),
                            child: Consumer<SubscriptionProvider>(
                              builder: (_, _, _) {
                                return PlanCard(
                                  plan: e.value,
                                  selected: _selectedPlan?.id == e.value.id,
                                  onSelect: () => setState(() => _selectedPlan = e.value),
                                );
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Consumer<AuthProvider>(
                          builder: (_, auth, _) {
                            if (auth.isAuthenticated) {
                              return CustomButton(
                                text: _selectedPlan != null
                                    ? 'Subscribe Now - ${formatRupee(_selectedPlan!.price)}'
                                    : 'Select a plan above',
                                onPressed: () => _confirmSubscribe(mess),
                              );
                            }
                            return CustomButton(
                              text: 'Login to Subscribe',
                              isOutlined: true,
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        _sectionTitle('Reviews (${mess.reviews.length})'),
                        const SizedBox(height: 4),
                        ...mess.reviews.map((r) => ReviewCard(review: r)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Consumer2<UserProvider, AuthProvider>(
            builder: (ctx, userProv, auth, _) {
              final bookmarked = userProv.isBookmarked(mess.id ?? '');
              return FloatingActionButton.extended(
                onPressed: () async {
                  if (!auth.isAuthenticated) {
                    showSnackbar(ctx, 'Please login to save messes');
                    return;
                  }
                  await userProv.toggleBookmark(auth.token!, mess.id ?? '', mess);
                  if (ctx.mounted) {
                    showSnackbar(ctx, bookmarked ? 'Removed from saved' : 'Mess saved!');
                  }
                },
                icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                label: Text(bookmarked ? 'Saved' : 'Save', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 17));
  }

  Widget _menuList(IconData icon, List<String> items, String emoji) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(emoji, style: const TextStyle(fontSize: 18))),
            minLeadingWidth: 10,
            contentPadding: EdgeInsets.zero,
            title: Text(
              items.isEmpty ? 'Not updated yet' : items.join(',  '),
              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
