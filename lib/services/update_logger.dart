import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UpdateEventType {
  checkStarted,
  checkSuccess,
  checkFailed,
  updateAvailable,
  updateIgnored,
  downloadStarted,
  downloadProgress,
  downloadSuccess,
  downloadFailed,
  installStarted,
  installSuccess,
  installFailed,
  maintenanceMode,
}

class UpdateEvent {
  final UpdateEventType type;
  final String? version;
  final String? message;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  UpdateEvent({
    required this.type,
    this.version,
    this.message,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'version': version,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class UpdateLogger {
  static const String _eventsKey = 'update_events';
  static const int _maxEvents = 100;
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> logEvent(UpdateEvent event) async {
    await init();
    
    final events = await getEvents();
    events.add(event);
    
    // Keep only last _maxEvents
    if (events.length > _maxEvents) {
      events.removeRange(0, events.length - _maxEvents);
    }
    
    await _prefs?.setString(_eventsKey, _eventsToJson(events));
    
    if (kDebugMode) {
      debugPrint('[UpdateLogger] ${event.type}: ${event.message ?? event.version}');
    }
  }

  static Future<List<UpdateEvent>> getEvents() async {
    await init();
    
    final eventsJson = _prefs?.getString(_eventsKey);
    if (eventsJson == null) return [];
    
    return _eventsFromJson(eventsJson);
  }

  static Future<void> clearEvents() async {
    await init();
    await _prefs?.remove(_eventsKey);
  }

  static String _eventsToJson(List<UpdateEvent> events) {
    return jsonEncode(events.map((e) => e.toJson()).toList());
  }

  static List<UpdateEvent> _eventsFromJson(String jsonString) {
    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded.map((e) => UpdateEvent(
        type: _parseEventType(e['type'] as String?),
        version: e['version'] as String?,
        message: e['message'] as String?,
        timestamp: DateTime.parse(e['timestamp'] as String),
        metadata: e['metadata'] as Map<String, dynamic>?,
      )).toList();
    } catch (e) {
      debugPrint('[UpdateLogger] Failed to parse events: $e');
      return [];
    }
  }

  static UpdateEventType _parseEventType(String? typeString) {
    if (typeString == null) return UpdateEventType.checkStarted;
    return UpdateEventType.values.firstWhere(
      (e) => e.toString() == typeString,
      orElse: () => UpdateEventType.checkStarted,
    );
  }
}
