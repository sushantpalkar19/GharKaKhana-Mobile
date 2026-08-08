import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../utils/snackbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessCityController = TextEditingController();
  final _businessPincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  String _selectedRole = 'customer';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessCityController.dispose();
    _businessPincodeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get role from navigation arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['role'] != null) {
      setState(() {
        _selectedRole = args['role'] as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account 🎉',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up for fresh homemade meals every day.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  hintText: 'e.g. Rahul Sharma',
                  prefixIcon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your name';
                    if (v.trim().split(' ').isEmpty) return 'Enter valid name';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: '10 digit mobile number',
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter phone';
                    final digits = v.replaceAll(RegExp(r'\D'), '');
                    if (digits.length != 10) return 'Must be 10 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) {
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                // Owner-specific fields
                if (_selectedRole == 'owner') ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'Business Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _businessNameController,
                    labelText: 'Business Name',
                    hintText: 'e.g. Sharma Home Mess',
                    prefixIcon: Icons.store,
                    validator: (v) {
                      if (_selectedRole == 'owner' && (v == null || v.isEmpty)) {
                        return 'Enter business name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: _businessAddressController,
                    labelText: 'Business Address',
                    hintText: 'Street address',
                    prefixIcon: Icons.location_on,
                    validator: (v) {
                      if (_selectedRole == 'owner' && (v == null || v.isEmpty)) {
                        return 'Enter business address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: _businessCityController,
                    labelText: 'City',
                    hintText: 'e.g. Mumbai',
                    prefixIcon: Icons.location_city,
                    validator: (v) {
                      if (_selectedRole == 'owner' && (v == null || v.isEmpty)) {
                        return 'Enter city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: _businessPincodeController,
                    labelText: 'Pincode',
                    hintText: '6 digit pincode',
                    prefixIcon: Icons.pin,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (_selectedRole == 'owner' && (v == null || v.isEmpty)) {
                        return 'Enter pincode';
                      }
                      final digits = v?.replaceAll(RegExp(r'\D'), '') ?? '';
                      if (digits.length != 6) return 'Must be 6 digits';
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 28),
                Consumer<AuthProvider>(
                  builder: (ctx, auth, child) {
                    return CustomButton(
                      text: 'Create Account',
                      isLoading: auth.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final ok = await auth.register(
                            _fullNameController.text.trim(),
                            _emailController.text.trim(),
                            _phoneController.text.trim(),
                            _passwordController.text.trim(),
                            role: _selectedRole,
                            businessName: _selectedRole == 'owner' ? _businessNameController.text.trim() : null,
                            businessAddress: _selectedRole == 'owner' ? _businessAddressController.text.trim() : null,
                            businessCity: _selectedRole == 'owner' ? _businessCityController.text.trim() : null,
                            businessPincode: _selectedRole == 'owner' ? _businessPincodeController.text.trim() : null,
                          );
                          if (ok) {
                            if (mounted) {
                              showSnackbar(ctx, 'Account created successfully! Please login.');
                              Navigator.pushReplacementNamed(ctx, '/login');
                            }
                          } else {
                            if (mounted) {
                              showSnackbar(ctx, auth.error ?? 'Registration failed', isError: true);
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
                      const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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
