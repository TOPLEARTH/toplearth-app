import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/app/config/app_routes.dart';

class OnBoardingMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (StorageFactory.systemProvider.getFirstRun()) {
      // 첫 실행 시 온보딩 페이지로 이동
      return const RouteSettings(name: AppRoutes.ON_BOARDING);
    }
    return null; // 첫 실행이 아니면 아무 것도 하지 않음
  }
}
