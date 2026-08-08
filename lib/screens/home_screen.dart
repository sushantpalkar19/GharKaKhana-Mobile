import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme.dart';
import '../models/mess.dart';
import '../providers/auth_provider.dart';
import '../providers/mess_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/mess_card.dart';
import 'profile_screen.dart';
import 'subscriptions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<MessProvider>().fetchMesses();
        context.read<SubscriptionProvider>().fetchMySubscriptions(auth.token!);
        context.read<UserProvider>().fetchBookmarks(auth.token!, context.read<MessProvider>().messes);
      } else {
        context.read<MessProvider>().fetchMesses();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int idx) {
    setState(() => _currentIndex = idx);
    _pageController.animateToPage(
      idx,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        actions: _buildActions(),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (idx) => setState(() => _currentIndex = idx),
        children: const [
          ExplorePage(),
          SubscriptionsScreen(insideHome: true),
          ProfileScreen(insideHome: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions_outlined), activeIcon: Icon(Icons.subscriptions), label: 'Subscriptions'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    switch (_currentIndex) {
      case 0:
        return Row(
          children: [
            Icon(Icons.restaurant_menu, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              'GharKaKhana',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        );
      case 1:
        return const Text('My Subscriptions');
      case 2:
        return const Text('My Profile');
      default:
        return const Text('GharKaKhana');
    }
  }

  List<Widget>? _buildActions() {
    if (_currentIndex != 0) return null;
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: MessSearchDelegate());
        },
      ),
      IconButton(
        icon: const Icon(Icons.bookmark_border),
        onPressed: () => Navigator.pushNamed(context, '/bookmarks'),
      ),
    ];
  }
}

class MessSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: AppColors.background,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textMuted),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    final messProv = context.read<MessProvider>();
    final all = messProv.messes;
    final filtered = query.isEmpty
        ? all
        : all.where((m) => m.name.toLowerCase().contains(query.toLowerCase()) || m.address.toLowerCase().contains(query.toLowerCase())).toList();
    if (filtered.isEmpty) {
      return Center(
        child: Text('No messes found for "$query"', style: const TextStyle(color: AppColors.textMuted)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => MessCard(mess: filtered[i]),
    );
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _selectedCuisine = 'All';
  static const List<String> _cuisines = [
    'All',
    'North Indian',
    'South Indian',
    'Pure Veg',
    'Jain',
    'High Protein',
  ];

  List<Mess> _applyFilter(List<Mess> all) {
    if (_selectedCuisine == 'All') return all;
    return all.where((m) => m.cuisineType.contains(_selectedCuisine)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MessProvider, UserProvider>(
      builder: (ctx, messProv, userProv, _) {
        final filtered = _applyFilter(messProv.filteredMesses);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Consumer<AuthProvider>(
              builder: (_, auth, _) => Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${auth.user?.fullName ?? "Guest"} 👋',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Find your favorite homemade food',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Featured Messes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 310,
              child: messProv.loading
                  ? _buildShimmerList(3, horizontal: true)
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: messProv.featuredMesses.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (ctx, i) => SizedBox(
                        width: 300,
                        child: MessCard(mess: messProv.featuredMesses[i]),
                      ),
                    ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _cuisines.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (ctx, i) {
                  final c = _cuisines[i];
                  final isSelected = _selectedCuisine == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCuisine = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('All Messes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text(
                  '${filtered.length} found',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            messProv.loading
                ? _buildShimmerList(4)
                : filtered.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Text(
                            'No messes found',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (ctx, i) => MessCard(mess: filtered[i]),
                      ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildShimmerList(int count, {bool horizontal = false}) {
    if (horizontal) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, _) => SizedBox(
          width: 300,
          child: _shimmerCard(),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, _) => _shimmerCard(),
    );
  }

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(height: 200, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(12)))),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 180, height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 8),
                  Container(width: 260, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 8),
                  Container(width: 140, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
