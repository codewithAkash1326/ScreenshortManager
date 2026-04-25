import 'package:dio/dio.dart';
import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/login/services/api_routes.dart';
import 'package:get/get.dart';

/// Centralized auth service for login & signup
class AuthService {
  AuthService({ApiService? api}) : _api = api ?? Get.find<ApiService>();

  final ApiService _api;
  Future<String> login({
    required String userName,
    required String password,
  }) async {
    final resp = await _api.dio.post(
      ApiRoutes.login,
      data: {"user_name": userName, "password": password},
    );

    final responseData = resp.data;

    if (resp.statusCode == 200 &&
        responseData != null &&
        responseData['data'] != null &&
        responseData['data'].isNotEmpty) {
      final token = responseData['data'][0]['token'];

      if (token != null) {
        return token as String;
      }
    }

    throw Exception(responseData?['error']?['message'] ?? 'Login failed');
  }

  Future<void> register({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    await _api.dio.post(
      ApiRoutes.register,
      data: {
        "name": name,
        "user_name": userName,
        "email": email,
        "password": password,
      },
    );
  }
}
