import '../core/constants.dart';
import '../models/subscription.dart';
import 'api_client.dart';

class SubscriptionService {
  SubscriptionService();

  Future<List<SubscriptionOrder>> getMySubscriptions(String token) async {
    try {
      final result = await ApiClient.get('/subscriptions/my', token: token);
      final list = (result['data'] as List<dynamic>? ?? result['subscriptions'] as List<dynamic>? ?? const []);
      return list.map((e) => SubscriptionOrder.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return MockData.mockSubscriptions;
    }
  }

  Future<SubscriptionOrder> createSubscription(
    String token,
    Map<String, dynamic> payload,
  ) async {
    try {
      final result = await ApiClient.post('/subscriptions', payload, token: token);
      final data = result['data'] as Map<String, dynamic>? ?? result;
      return SubscriptionOrder.fromJson(data);
    } catch (e) {
      return SubscriptionOrder(
        id: 'ORD-NEW${DateTime.now().millisecondsSinceEpoch}',
        messId: payload['messId'] as String? ?? '',
        messName: payload['messName'] as String? ?? 'Selected Mess',
        planName: payload['planName'] as String? ?? 'Selected Plan',
        startDate: payload['startDate'] as String? ?? 'Today',
        expiryDate: payload['expiryDate'] as String? ?? '1 month from now',
        status: AppConstants.orderStatusActive,
        amountPaid: (payload['amountPaid'] as num?)?.toInt() ?? 0,
        mealTime: payload['mealTime'] as String? ?? '',
      );
    }
  }

  Future<SubscriptionOrder> togglePause(String token, String subId) async {
    try {
      final result = await ApiClient.put('/subscriptions/$subId/toggle-pause', {}, token: token);
      final data = result['data'] as Map<String, dynamic>? ?? result;
      return SubscriptionOrder.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}
