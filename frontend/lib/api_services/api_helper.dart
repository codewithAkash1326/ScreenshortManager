import 'package:dio/dio.dart';
import 'package:frontend/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.1.7:8000", // FastAPI local
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final box = GetStorage();
          final token = box.read('token');

          if (token != null) {
            options.headers["Authorization"] = "$token";
          }

          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response!.statusCode == 401) {
            Get.toNamed(AppRoutes.LOGIN);
          }

          return handler.next(error);
        },
      ),
    );
  }
}
