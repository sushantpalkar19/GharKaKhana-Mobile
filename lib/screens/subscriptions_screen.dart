import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';

class SubscriptionsScreen extends StatefulWidget {
  final bool insideHome;

  const SubscriptionsScreen({super.key, this.insideHome = false});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final subProv = context.read<SubscriptionProvider>();
      if (auth.isAuthenticated && subProv.subs.isEmpty) {
        subProv.fetchMySubscriptions(auth.token ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Consumer2<SubscriptionProvider, AuthProvider>(
      builder: (ctx, subProv, auth, _) {
        if (subProv.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final active = subProv.activeSubscription;
        final past = subProv.pastSubscriptions;

        if (!auth.isAuthenticated || subProv.subs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[200]),
                  const SizedBox(height: 16),
                  Text('No subscriptions yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    auth.isAuthenticated
                        ? 'Browse messes and subscribe to homemade meals'
                        : 'Login to view your subscriptions',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  auth.isAuthenticated
                      ? CustomButton(
                          text: 'Browse Messes',
                          isOutlined: true,
                          width: 220,
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/home');
                          },
                        )
                      : CustomButton(
                          text: 'Login',
                          width: 220,
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                        ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (active != null) ...[
              Row(
                children: [
                  Icon(Icons.verified, color: AppColors.success, size: 18),
                  const SizedBox(width: 6),
                  Text('Active Plan', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              _buildActiveCard(active, subProv, auth),
              const SizedBox(height: 28),
            ],
            Row(
              children: [
                Icon(Icons.history, color: AppColors.textMuted, size: 18),
                const SizedBox(width: 6),
                Text('Past Plans', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            if (past.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No past orders', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                ),
              )
            else
              ...past.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPastCard(s),
                  )),
            const SizedBox(height: 24),
          ],
        );
      },
    );

    if (widget.insideHome) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Subscriptions')),
      body: content,
    );
  }

  Widget _buildActiveCard(dynamic sub, SubscriptionProvider subProv, AuthProvider auth) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: AppColors.primary.withOpacity(0.08),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.subscriptions, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sub.messName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(sub.planName, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text('Valid: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          Flexible(
                            child: Text(
                              '${formatDate(sub.startDate)} - ${formatDate(sub.expiryDate)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: statusColor(sub.status), borderRadius: BorderRadius.circular(6)),
                            child: Text(sub.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sub.mealTime,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(formatRupee(sub.amountPaid), style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: sub.status == AppConstants.orderStatusActive ? 'Pause' : 'Resume',
                    isOutlined: true,
                    height: 42,
                    onPressed: () async {
                      await subProv.togglePauseSubscription(auth.token ?? '', sub.id);
                    },
                  ),
                ),
                if (sub.status == AppConstants.orderStatusActive) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: 'View Mess',
                      height: 42,
                      onPressed: () => Navigator.pushNamed(context, '/mess-detail', arguments: sub.messId),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastCard(dynamic sub) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: AppColors.card,
      margin: EdgeInsets.zero,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.border.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.receipt_long_outlined, color: AppColors.textMuted, size: 22),
        ),
        title: Text(sub.messName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sub.planName, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: statusColor(sub.status).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(sub.status, style: TextStyle(color: statusColor(sub.status), fontWeight: FontWeight.w600, fontSize: 10)),
                  ),
                  const SizedBox(width: 6),
                  Text(formatDate(sub.expiryDate), style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        trailing: Text(formatRupee(sub.amountPaid), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
      ),
    );
  }
}
