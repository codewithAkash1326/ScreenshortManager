import 'package:frontend/home/models/screenshot_item.dart';
import 'package:frontend/home/models/screenshot_response.dart';
import 'package:frontend/home/services/home_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final HomeService _service = Get.find<HomeService>();

  // Observable response and list (similar to portfolio pattern)
  final Rx<ScreenshotResponse?> screenshotResponse = Rx<ScreenshotResponse?>(
    null,
  );
  final RxList<ScreenshotItem> shots = RxList<ScreenshotItem>([]);
  final RxBool isLoading = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShots();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;

    if (index == 2) {
      final box = GetStorage();
      box.remove('token');

      Get.offAllNamed('/login');
    }
  }

  Future<void> fetchShots() async {
    try {
      isLoading.value = true;
      final res = await _service.fetchScreenshots();
      screenshotResponse.value = res;
      shots.assignAll(res.items);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load screenshots');
    } finally {
      isLoading.value = false;
    }
  }
}
