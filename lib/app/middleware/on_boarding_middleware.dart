import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/app/config/app_routes.dart';

/// 온보딩 뷰 테스트용
// class OnBoardingMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     // Always redirect to onboarding for debugging
//     return const RouteSettings(name: AppRoutes.ON_BOARDING);
//   }
// }

class OnBoardingMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (StorageFactory.systemProvider.getFirstRun()) {
      StorageFactory.systemProvider.setFirstRun(false);
      return const RouteSettings(name: AppRoutes.ON_BOARDING);
    }
    return null;
  }
}
