import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme.dart';
import '../models/mess.dart';
import '../providers/auth_provider.dart';
import '../providers/mess_provider.dart';
import '../widgets/mess_card.dart';
import 'mess_detail_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  static const List<Map<String, dynamic>> _foodCategories = [
    {'emoji': '🍛', 'name': 'Thali'},
    {'emoji': '🍱', 'name': 'Tiffin'},
    {'emoji': '🥘', 'name': 'Homemade'},
    {'emoji': '🥗', 'name': 'Healthy'},
    {'emoji': '🍚', 'name': 'Meals'},
    {'emoji': '🥙', 'name': 'Snacks'},
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  List<Mess> _filterMesses(List<Mess> messes) {
    if (_selectedCategory == 'All') return messes;
    return messes.where((m) => m.tags.contains(_selectedCategory)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<AuthProvider>(
                  builder: (_, auth, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_getGreeting()}, ${auth.user?.fullName?.split(' ').first ?? 'Guest'} 👋',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Current Location',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Icon(Icons.notifications_outlined, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'What are you hungry for today?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: '🔍 Search messes, dishes or food',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Food Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _foodCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (ctx, i) {
                    final category = _foodCategories[i];
                    final isSelected = _selectedCategory == category['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category['name'] as String),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              category['emoji'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category['name'] as String,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Nearby Messes Section
            Consumer<MessProvider>(
              builder: (_, messProv, __) {
                final filtered = _filterMesses(messProv.filteredMesses);
                final searchQuery = _searchController.text.toLowerCase();
                final searched = searchQuery.isEmpty
                    ? filtered
                    : filtered.where((m) =>
                        m.name.toLowerCase().contains(searchQuery) ||
                        m.address.toLowerCase().contains(searchQuery) ||
                        m.tags.any((t) => t.toLowerCase().contains(searchQuery))).toList();

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        children: [
                          Text(
                            'Nearby Messes',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${searched.length} found',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (messProv.loading)
                        _buildShimmerList(4)
                      else if (searched.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                                const SizedBox(height: 12),
                                Text(
                                  'No messes found',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...searched.map((mess) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildMessCard(mess),
                            )),
                      const SizedBox(height: 24),
                    ]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessCard(Mess mess) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/mess-detail', arguments: mess),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mess Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                mess.image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: AppColors.surface,
                  child: Icon(Icons.restaurant, size: 48, color: AppColors.textMuted),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mess.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                              'Open',
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        mess.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${mess.totalReviews})',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Text(
                        mess.distance,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${mess.priceStartingAt} onwards',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'View Menu',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildShimmerList(int count) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.border,
        highlightColor: Colors.white,
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
