import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/presentation/view_model/root/root_binding.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // RootBinding 실행으로 의존성 등록
    RootBinding().dependencies();

    final RootViewModel rootViewModel = Get.find<RootViewModel>();

    // 데이터 초기화 후 RootScreen으로 이동
    if(rootViewModel.initialized) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed(AppRoutes.ROOT);
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('로딩 중...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
