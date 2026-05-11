import 'dart:io';

import 'package:frontend/app_routes.dart';
import 'package:frontend/home/models/screenshot_item.dart';
import 'package:frontend/home/models/screenshot_response.dart';
import 'package:frontend/home/services/home_service.dart';
import 'package:frontend/utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final HomeService _service = Get.find<HomeService>();

  // Observable response and list (similar to portfolio pattern)
  final Rx<ScreenshotResponse?> screenshotResponse = Rx<ScreenshotResponse?>(
    null,
  );
  final RxList<ScreenshotItem> shots = RxList<ScreenshotItem>([]);
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShots();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    // index: 0 => Home, 1 => About
  }

  void logout() {
    final box = GetStorage();
    box.remove('token');
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  Future<void> fetchShots() async {
    try {
      print("before api");
      isLoading.value = true;
      final res = await _service.fetchScreenshots();
      print("after api");
      screenshotResponse.value = res;
      shots.assignAll(res.items);
    } catch (e) {
      print("catch error $e");
      UiUtils.showError('Failed to load screenshots');
    } finally {
      print("finally");
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      if (isUploading.value) return;

      final picker = ImagePicker();

      final XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file == null) return;

      isUploading.value = true;
      await _service.uploadImage(File(file.path));
      await fetchShots();

      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }

      UiUtils.showSuccess("Image uploaded");
    } catch (e) {
      print(e);

      UiUtils.showError("Upload failed");
    } finally {
      isUploading.value = false;
    }
  }
}
