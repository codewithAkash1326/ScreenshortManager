import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/auth/services/api_routes.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<String> loginWithFirebaseToken({required String firebaseToken}) async {
    final resp = await _api.dio.post(
      ApiRoutes.login,
      data: {"token": firebaseToken},
    );

    final responseData = resp.data;
    final data = responseData is Map<String, dynamic>
        ? responseData["data"]
        : null;

    if (resp.statusCode == 200 && data is List && data.isNotEmpty) {
      final token = data[0]["token"];
      if (token is String && token.isNotEmpty) {
        return token;
      }
    }

    final error = responseData is Map<String, dynamic>
        ? responseData["error"]
        : null;

    final message = error is Map<String, dynamic> ? error["message"] : null;
    throw Exception(
      (message is String && message.isNotEmpty) ? message : "Login failed",
    );
  }
}
