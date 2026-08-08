import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/mess_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/user_provider.dart';
import 'providers/update_provider.dart';
import 'providers/theme_provider.dart';
import 'services/app_version_service.dart';
import 'services/theme_service.dart';
import 'services/update_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mess_detail_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/owner_verification_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/theme_onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for theme persistence
  await ThemeService.init();
  
  // Initialize update service
  final appVersionService = AppVersionService();
  final updateService = CustomUpdateService(appVersionService);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubscriptionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UpdateProvider(updateService)..init(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedTheme(
          data: themeProvider.themeData,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GharKaKhana',
            theme: themeProvider.themeData,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/theme-onboarding': (context) => const ThemeOnboardingScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/role-selection': (context) => const RoleSelectionScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/mess-detail': (context) => const MessDetailScreen(),
              '/messDetail': (context) => const MessDetailScreen(),
              '/subscriptions': (context) => const SubscriptionsScreen(),
              '/bookmarks': (context) => const BookmarksScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/owner-verification': (context) => const OwnerVerificationScreen(),
              '/maintenance': (context) => const MaintenanceScreen(),
              '/change-password': (context) => const ChangePasswordScreen(),
              '/admin-dashboard': (context) => const AdminDashboardScreen(),
            },
          ),
        );
      },
    );
  }
}
