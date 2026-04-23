import 'package:frontend/api_services/api_helper.dart';
import 'package:frontend/home/controller/home_controller.dart';
import 'package:frontend/home/services/home_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }
    if (!Get.isRegistered<HomeService>()) {
      Get.put<HomeService>(HomeService(api: Get.find<ApiService>()), permanent: true);
    }
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
