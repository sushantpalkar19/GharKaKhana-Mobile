import '../models/mess.dart';
import 'api_client.dart';

class UserService {
  UserService();

  Future<List<Mess>> getBookmarks(String token, List<Mess> allMesses) async {
    try {
      final result = await ApiClient.get('/user/bookmarks', token: token);
      final list = (result['data'] as List<dynamic>? ?? result['bookmarks'] as List<dynamic>? ?? const []);
      final bookmarkIds = list.map((e) => e.toString()).toSet();
      return allMesses.where((m) => bookmarkIds.contains(m.id)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleBookmark(String token, String messId) async {
    try {
      await ApiClient.post('/user/bookmarks/toggle', {'messId': messId}, token: token);
    } catch (e) {
      // ignore
    }
  }
}
