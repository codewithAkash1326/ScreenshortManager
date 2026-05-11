import 'package:dio/dio.dart';
import 'package:frontend/search/services/search_services.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final SearchService _service = SearchService();

  final isLoading = false.obs;
  final results = <String>[].obs;

  final hasSearched = false.obs;
  final noResults = false.obs;
  final hasError = false.obs;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      results.clear();
      hasSearched.value = false;
      noResults.value = false;
      hasError.value = false;
      return;
    }

    try {
      isLoading.value = true;

      hasSearched.value = true;
      noResults.value = false;
      hasError.value = false;

      final res = await _service.searchImages(query: query);

      results.assignAll(res);

      if (res.isEmpty) {
        noResults.value = true;
      }
    } on DioException catch (e) {
      results.clear();

      if (e.response?.statusCode == 404) {
        noResults.value = true;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      results.clear();
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
