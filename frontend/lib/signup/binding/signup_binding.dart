import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
