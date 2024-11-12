import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/presentation/view/root/root_screen.dart';

import '../../presentation/view_model/root/root_binding.dart';

abstract class AppPages {
  static List<GetPage> data = [
    GetPage(
      name: AppRoutes.ROOT,
      page: () => const RootScreen(),
      binding: RootBinding(),
    ),
  ];
}