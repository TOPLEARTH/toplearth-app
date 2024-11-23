import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/app/config/app_routes.dart';

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
