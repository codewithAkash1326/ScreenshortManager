import 'package:frontend/app_routes.dart';
import 'package:frontend/home/binding/home_binding.dart';
import 'package:frontend/home/view/home_view.dart';
import 'package:frontend/home/view/image_view.dart';
import 'package:frontend/login/binding/login_binding.dart';
import 'package:frontend/login/view/login_view.dart';
import 'package:frontend/search/bindings/search_bindings.dart';
import 'package:frontend/search/view/search_screen.dart';
import 'package:frontend/signup/binding/signup_binding.dart';
import 'package:frontend/signup/view/signup_view.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(name: AppRoutes.IMAGE_VIEWER, page: () => const ImageViewerPage()),
  ];
}
