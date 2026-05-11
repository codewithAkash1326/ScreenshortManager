import 'package:frontend/app_routes.dart';
import 'package:frontend/auth/bindings/auth_binding.dart';
import 'package:frontend/auth/view/forgot_password_view.dart';
import 'package:frontend/auth/view/login_view.dart';
import 'package:frontend/auth/view/signup_view.dart';
import 'package:frontend/home/binding/home_binding.dart';
import 'package:frontend/home/view/home_view.dart';
import 'package:frontend/home/view/image_view.dart';
import 'package:frontend/search/bindings/search_bindings.dart';
import 'package:frontend/search/view/search_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
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
