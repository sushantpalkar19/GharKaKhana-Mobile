import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../models/mess.dart';
import '../services/mess_service.dart';

class MessProvider extends ChangeNotifier {
  List<Mess> _messes = [];
  Mess? _selectedMess;
  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCuisine = 'All';

  final MessService _messService;

  MessProvider({MessService? messService})
      : _messService = messService ?? MessService();

  List<Mess> get messes => _messes;
  Mess? get selectedMess => _selectedMess;
  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCuisine => _selectedCuisine;

  List<Mess> get filteredMesses {
    if (_selectedCuisine == 'All') return _messes;
    return filterByCuisine(_selectedCuisine);
  }

  Future<void> fetchMesses({String? search}) async {
    _loading = true;
    _error = null;
    if (search != null) _searchQuery = search;
    notifyListeners();

    try {
      final result = await _messService.getMesses(search: search);
      _messes = result.isNotEmpty ? result : MockData.mockMesses;
    } catch (_) {
      _messes = MockData.mockMesses;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Mess?> fetchMessDetail(String id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _messService.getMessById(id);
      _selectedMess = result;
    } catch (_) {
      try {
        _selectedMess = MockData.mockMesses.firstWhere((m) => m.id == id);
      } catch (_) {
        _selectedMess = null;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }

    return _selectedMess;
  }

  void setCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    notifyListeners();
  }

  List<Mess> filterByCuisine(String cuisine) {
    return _messes.where((mess) {
      final cuisineMatch = mess.cuisineType
          .any((c) => c.toLowerCase().contains(cuisine.toLowerCase()));
      final tagsMatch = mess.tags
          .any((t) => t.toLowerCase().contains(cuisine.toLowerCase()));
      return cuisineMatch || tagsMatch;
    }).toList();
  }

  List<Mess> get featuredMesses {
    final sorted = List<Mess>.from(_messes)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(3).toList();
  }
}
