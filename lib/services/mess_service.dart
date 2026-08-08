import '../core/constants.dart';
import '../models/mess.dart';
import 'api_client.dart';

class MessService {
  MessService();

  Future<List<Mess>> getMesses({String? search}) async {
    try {
      final result = await ApiClient.get('/messes');
      final list = (result['data'] as List<dynamic>? ?? result['messes'] as List<dynamic>? ?? const []);
      return list.map((e) => Mess.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return MockData.mockMesses;
    }
  }

  Future<Mess> getMessById(String messId) async {
    try {
      final result = await ApiClient.get('/messes/$messId');
      final data = result['data'] as Map<String, dynamic>? ?? result;
      return Mess.fromJson(data);
    } catch (e) {
      final matches = MockData.mockMesses.where((m) => m.id == messId);
      if (matches.isNotEmpty) return matches.first;
      return MockData.mockMesses.first;
    }
  }
}
