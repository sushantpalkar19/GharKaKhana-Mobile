import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../models/subscription.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionOrder> _subs = [];
  bool _loading = false;
  String? _error;

  final SubscriptionService _subService;

  SubscriptionProvider({SubscriptionService? subService})
      : _subService = subService ?? SubscriptionService();

  List<SubscriptionOrder> get subs => _subs;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchMySubscriptions(String token) async {
    _loading = true;
    notifyListeners();

    try {
      final list = await _subService.getMySubscriptions(token);
      _subs = list.isNotEmpty ? list : MockData.mockSubscriptions;
    } catch (_) {
      _subs = MockData.mockSubscriptions;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<SubscriptionOrder?> subscribe(
    String token, {
    required String messId,
    required String messName,
    required String planName,
    required int amountPaid,
    required String startDate,
    required String expiryDate,
    required String mealTime,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final payload = {
        'messId': messId,
        'messName': messName,
        'planName': planName,
        'amountPaid': amountPaid,
        'startDate': startDate,
        'expiryDate': expiryDate,
        'mealTime': mealTime,
      };

      final newSub = await _subService.createSubscription(token, payload);
      _subs.insert(0, newSub);
      return newSub;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> togglePauseSubscription(String token, String subId) async {
    try {
      final updated = await _subService.togglePause(token, subId);
      final index = _subs.indexWhere((s) => s.id == subId);
      if (index != -1) {
        _subs[index] = updated;
      } else {
        final idx = _subs.indexWhere((s) => s.id == subId);
        if (idx != -1) {
          final current = _subs[idx];
          final newStatus = current.status == AppConstants.orderStatusActive
              ? AppConstants.orderStatusPaused
              : AppConstants.orderStatusActive;
          _subs[idx] = current.copyWith(status: newStatus);
        }
      }
    } catch (_) {
      final idx = _subs.indexWhere((s) => s.id == subId);
      if (idx != -1) {
        final current = _subs[idx];
        final newStatus = current.status == AppConstants.orderStatusActive
            ? AppConstants.orderStatusPaused
            : AppConstants.orderStatusActive;
        _subs[idx] = current.copyWith(status: newStatus);
      }
    }
    notifyListeners();
  }

  SubscriptionOrder? get activeSubscription {
    try {
      return _subs.firstWhere(
        (s) => s.status == AppConstants.orderStatusActive,
      );
    } catch (_) {
      return null;
    }
  }

  List<SubscriptionOrder> get pastSubscriptions {
    return _subs
        .where((s) => s.status != AppConstants.orderStatusActive)
        .toList();
  }
}
