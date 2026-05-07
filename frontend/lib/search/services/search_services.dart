import 'package:frontend/api_services/api_helper.dart';

class SearchService {
  final ApiService _api = ApiService();

  Future<List<String>> searchImages({required String query}) async {
    try {
      final resp = await _api.dio.get(
        '/screenshot/search',
        queryParameters: {"query": query},
      );

      final data = resp.data as Map<String, dynamic>;
      final List list = data['data'] ?? [];

      return list.map((e) => e.toString()).toList();
    } catch (e) {
      throw Exception("Search API failed: $e");
    }
  }
}
