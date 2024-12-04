import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/data/factory/storage_factory.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isNotLogin = !StorageFactory.systemProvider.isLogin;

    if (isNotLogin) {
      // 로그인 상태가 아니면 로그인 페이지로 이동
      return const RouteSettings(name: AppRoutes.LOGIN);
    }

    return null; // 로그인 상태면 아무 것도 하지 않음
  }
}
