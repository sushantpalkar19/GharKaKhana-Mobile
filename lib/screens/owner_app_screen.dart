import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import 'owner_dashboard_screen.dart';
import 'owner_orders_screen.dart';
import 'owner_menu_screen.dart';
import 'owner_earnings_screen.dart';
import 'owner_reviews_screen.dart';
import 'profile_screen.dart';

class OwnerAppScreen extends StatefulWidget {
  const OwnerAppScreen({super.key});

  @override
  State<OwnerAppScreen> createState() => _OwnerAppScreenState();
}

class _OwnerAppScreenState extends State<OwnerAppScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: const [
          OwnerDashboardScreen(),
          OwnerOrdersScreen(),
          OwnerMenuScreen(),
          OwnerEarningsScreen(),
          OwnerReviewsScreen(),
          ProfileScreen(insideHome: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
