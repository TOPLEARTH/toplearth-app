import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/middleware/login_middleware.dart';
import 'package:toplearth/app/middleware/on_boarding_middleware.dart';
import 'package:toplearth/presentation/view/login/login_screen.dart';
import 'package:toplearth/presentation/view/on_boarding/on_boarding_screen.dart';
import 'package:toplearth/presentation/view/root/root_screen.dart';
import 'package:toplearth/presentation/view_model/login/login_binding.dart';
import 'package:toplearth/presentation/view_model/root/root_binding.dart';


abstract class AppPages {
  static List<GetPage> data = [
    GetPage(
      name: AppRoutes.ROOT,
      page: () => const RootScreen(),
      binding: RootBinding(),
      middlewares: [
        OnBoardingMiddleware(),
        LoginMiddleware(),
      ],
    ),
      GetPage(
        name: AppRoutes.LOGIN,
        page: () => const LoginScreen(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: AppRoutes.ON_BOARDING,
        page: () => const OnBoardingScreen(),
      ),
  ];
}