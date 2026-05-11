import 'package:frontend/home/controller/home_controller.dart';
import 'package:frontend/home/services/home_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Same style as search binding: keep DI simple and let services
    // manage their own ApiService instances.
    Get.lazyPut(() => HomeService());
    Get.lazyPut(() => HomeController());
  }
}
