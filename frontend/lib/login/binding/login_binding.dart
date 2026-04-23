import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/login/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
