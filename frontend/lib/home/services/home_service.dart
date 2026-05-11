import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/home/models/screenshot_response.dart';

class HomeService {
  final ApiService _api = ApiService();

  Future<ScreenshotResponse> fetchScreenshots() async {
    final resp = await _api.dio.get('/screenshot/get_images');
    final data = resp.data as Map<String, dynamic>;
    return ScreenshotResponse.fromJson(data);
  }

  Future<void> uploadImage(File file) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : "upload.png",
      ),
    });

    await _api.dio.post(
      "/screenshot/upload",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );
  }
}
