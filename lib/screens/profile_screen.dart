import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import 'appearance_settings_screen.dart';
import '../providers/subscription_provider.dart';
import '../providers/update_provider.dart';
import '../services/permission_service.dart';
import '../utils/snackbar.dart';
import '../widgets/update_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final bool insideHome;

  const ProfileScreen({super.key, this.insideHome = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final isGranted = await PermissionService.isNotificationGranted();
    if (mounted) {
      setState(() => _notificationsEnabled = isGranted);
    }
  }

  Future<void> _handleNotificationToggle(bool value) async {
    if (value) {
      // User wants to enable notifications - request permission
      final isGranted = await PermissionService.requestNotificationPermission();
      
      if (isGranted) {
        setState(() => _notificationsEnabled = true);
        if (mounted) {
          showSnackbar(context, 'Notifications enabled');
        }
      } else {
        // Permission denied
        final isPermanentlyDenied = await PermissionService.isNotificationPermanentlyDenied();
        if (mounted) {
          setState(() => _notificationsEnabled = false);
          if (isPermanentlyDenied) {
            _showSettingsDialog();
          } else {
            _showRationaleDialog();
          }
        }
      }
    } else {
      // User wants to disable notifications - just update state
      setState(() => _notificationsEnabled = false);
      if (mounted) {
        showSnackbar(context, 'Notifications disabled');
      }
    }
  }

  void _showRationaleDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          PermissionService.notificationRationale,
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleNotificationToggle(true);
            },
            child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Notifications Disabled', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'You have permanently denied notification permissions. To enable notifications, please open app settings and grant the permission.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              PermissionService.openNotificationSettings();
            },
            child: const Text('Open Settings', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates(BuildContext context) async {
    final updateProvider = context.read<UpdateProvider>();
    await updateProvider.checkForUpdate(forceCheck: true);
    
    if (!context.mounted) return;
    
    if (updateProvider.isUpdateAvailable) {
      final appVersion = updateProvider.appVersion;
      if (appVersion == null) return;
      
      showDialog(
        context: context,
        builder: (ctx) => UpdateDialog(
          appVersion: appVersion,
          currentVersion: '1.0.0', // TODO: Get from package_info
          forceUpdate: appVersion.forceUpdate,
          onUpdateNow: () {
            // TODO: Implement download and install
            Navigator.of(ctx).pop();
          },
          onLater: () {
            Navigator.of(ctx).pop();
            updateProvider.ignoreVersion();
          },
        ),
      );
    } else if (updateProvider.isUpToDate) {
      showSnackbar(context, 'You are using the latest version');
    } else if (updateProvider.hasError) {
      showSnackbar(context, updateProvider.errorMessage ?? 'Failed to check for updates', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Consumer2<AuthProvider, SubscriptionProvider>(
      builder: (ctx, auth, subProv, _) {
        if (!auth.isAuthenticated) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline, size: 80, color: Colors.grey[200]),
                  const SizedBox(height: 16),
                  Text('Please login to view profile', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Login',
                    width: 200,
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                ],
              ),
            ),
          );
        }
        final user = auth.user;
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          children: [
            const SizedBox(height: 10),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: (user?.profileImage != null && user!.profileImage!.isNotEmpty)
                        ? CachedNetworkImageProvider(user.profileImage!)
                        : null,
                    child: (user?.profileImage == null || user!.profileImage!.isEmpty)
                        ? Text(
                            (user?.fullName ?? 'G').substring(0, 1).toUpperCase(),
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.primary),
                          )
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? '',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(user?.email ?? '', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(user.phone ?? '', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ],
                          const SizedBox(height: 6),
                          if (user?.isVerified ?? false)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              backgroundColor: AppColors.secondary,
                              side: BorderSide.none,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.zero,
                              avatar: const Icon(Icons.check, color: Colors.white, size: 14),
                              label: const Text('Verified', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _sectionTitle('Quick Actions'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ProfileActionCard(
                  icon: Icons.subscriptions,
                  color: AppColors.primary,
                  name: 'My Plans',
                  onTap: () => Navigator.pushNamed(context, '/subscriptions'),
                ),
                ProfileActionCard(
                  icon: Icons.bookmark,
                  color: AppColors.secondary,
                  name: 'Saved Messes',
                  onTap: () => Navigator.pushNamed(context, '/bookmarks'),
                ),
                ProfileActionCard(
                  icon: Icons.receipt_long,
                  color: AppColors.accent,
                  name: 'Order History',
                  onTap: () => Navigator.pushNamed(context, '/subscriptions'),
                ),
                ProfileActionCard(
                  icon: Icons.help_outline,
                  color: Colors.indigo,
                  name: 'Help & FAQ',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Help & FAQ', style: TextStyle(fontWeight: FontWeight.w800)),
                        content: const SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('📞 Support', style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(height: 4),
                              Text('support@gharkakhana.com', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              SizedBox(height: 16),
                              Text('📋 Pause Policy', style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(height: 4),
                              Text('You can pause your subscription up to 5 days per month free.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              SizedBox(height: 16),
                              Text('💰 Refunds', style: TextStyle(fontWeight: FontWeight.w700)),
                              SizedBox(height: 4),
                              Text('Refunds processed within 7 working days for cancelled plans.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            _sectionTitle('Account Settings'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.edit_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Edit Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.lock_outline, color: AppColors.primary, size: 22),
                    title: const Text('Change Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.notifications_none, color: AppColors.primary, size: 22),
                    title: const Text('Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: _handleNotificationToggle,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.palette_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Appearance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppearanceSettingsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.location_on_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Saved Addresses', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _sectionTitle('About'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.info_outline, color: AppColors.primary, size: 22),
                    title: const Text('App Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Text(
                      '1.0.0', // TODO: Get from package_info
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.system_update, color: AppColors.primary, size: 22),
                    title: const Text('Check for Updates', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    onTap: () => _checkForUpdates(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (auth.isAuthenticated)
              Consumer<AuthProvider>(
                builder: (ctx, authProv, _) {
                  return CustomButton(
                    text: 'Logout',
                    color: Colors.red,
                    isOutlined: true,
                    onPressed: () async {
                      await authProv.logout();
                      if (ctx.mounted) {
                        Navigator.pushNamedAndRemoveUntil(ctx, '/login', (r) => false);
                        showSnackbar(ctx, 'Logged out successfully');
                      }
                    },
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
        );
      },
    );

    if (widget.insideHome) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: content,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary));
  }
}

class ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final VoidCallback onTap;

  const ProfileActionCard({
    super.key,
    required this.icon,
    required this.color,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (w - 48 - 12) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
