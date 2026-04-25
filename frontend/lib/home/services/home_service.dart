import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/home/models/screenshot_response.dart';

class HomeService {
  HomeService({required ApiService api}) : _api = api;
  final ApiService _api;

  Future<ScreenshotResponse> fetchScreenshots() async {
    print("api calling");
    final resp = await _api.dio.get('/screenshot/get_images');
    final data = resp.data as List<dynamic>;
    return ScreenshotResponse.fromJson(data as Map<String, dynamic>);
  }
}
