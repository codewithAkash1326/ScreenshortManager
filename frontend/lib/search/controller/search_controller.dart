import 'package:frontend/search/services/search_services.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final SearchService _service = SearchService();

  final isLoading = false.obs;
  final results = <String>[].obs;

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;

      final res = await _service.searchImages(query: query);
      results.assignAll(res);
    } catch (e) {
      Get.snackbar("Error", "Search failed");
    } finally {
      isLoading.value = false;
    }
  }
}
