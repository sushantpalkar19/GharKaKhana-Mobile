import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/config/api_config.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/mess_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/user_provider.dart';
import '../utils/snackbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[LoginScreen] initState — detected platform: ${ApiConfig.platformLabel}');
      debugPrint('[LoginScreen] initState — baseUrl: ${ApiConfig.baseUrl}');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Welcome Back! 👋',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to continue your homemade food journey.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 36),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'you@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter email';
                    if (!v.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _obscure ? Icons.visibility_off : Icons.visibility,
                  obscureText: _obscure,
                  onSuffixTap: () => setState(() => _obscure = !_obscure),
                  validator: (v) {
                    if (v == null || v.length < 6) return 'Min 6 chars';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (ctx, auth, child) {
                    return CustomButton(
                      text: 'Login',
                      isLoading: auth.isLoading,
                      onPressed: () async {
                        debugPrint('[LoginScreen] Login button pressed');
                        final valid = _formKey.currentState?.validate() ?? false;
                        debugPrint('[LoginScreen] Validation passed: $valid');
                        if (valid) {
                          debugPrint('[LoginScreen] Calling AuthProvider.login with email=${_emailController.text.trim()}');
                          final ok = await auth.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          debugPrint('[LoginScreen] AuthProvider.login returned ok=$ok');
                          if (ok) {
                            if (mounted) {
                              showSnackbar(ctx, 'Welcome back!');
                              // Fetch data based on role
                              if (auth.user?.role == 'customer') {
                                ctx.read<MessProvider>().fetchMesses();
                                ctx.read<SubscriptionProvider>().fetchMySubscriptions(auth.token!);
                                ctx.read<UserProvider>().fetchBookmarks(auth.token!, ctx.read<MessProvider>().messes);
                              }
                              // Navigate to appropriate dashboard based on role and status
                              final dashboardRoute = auth.getDashboardRoute();
                              debugPrint('[LoginScreen] Navigating to dashboardRoute=$dashboardRoute');
                              Navigator.pushReplacementNamed(ctx, dashboardRoute);
                              debugPrint('[LoginScreen] Navigation call completed');
                            }
                          } else {
                            if (mounted) {
                              showSnackbar(ctx, auth.error ?? 'Login failed', isError: true);
                            }
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('New user? ', style: TextStyle(color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/role-selection'),
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showSnackbar(context, 'Browsing as guest');
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
