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
    if (resp.statusCode == 200 && resp.data?['token'] != null) {
      return resp.data['token'] as String;
    }
    throw Exception(resp.data?['detail'] ?? 'Login failed');
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
