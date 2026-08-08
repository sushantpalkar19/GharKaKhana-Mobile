import 'package:flutter/foundation.dart';

import '../models/mess.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  List<Mess> _bookmarks = [];
  bool _loading = false;
  String? _error;

  final UserService _userService;

  UserProvider({UserService? userService})
      : _userService = userService ?? UserService();

  List<Mess> get bookmarks => _bookmarks;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchBookmarks(String token, List<Mess> allMesses) async {
    _loading = true;
    notifyListeners();

    try {
      _bookmarks = await _userService.getBookmarks(token, allMesses);
    } catch (_) {
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleBookmark(String token, String messId, Mess mess) async {
    try {
      await _userService.toggleBookmark(token, messId);
      final existingIndex = _bookmarks.indexWhere((m) => m.id == messId);
      if (existingIndex != -1) {
        _bookmarks.removeAt(existingIndex);
      } else {
        _bookmarks.add(mess);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool isBookmarked(String messId) =>
      _bookmarks.any((m) => m.id == messId);
}
