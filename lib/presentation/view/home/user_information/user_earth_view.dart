import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/presentation/view/widget/custom_model_viewer.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';

class UserEarthView extends StatelessWidget {
  const UserEarthView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    String getAnimationFile() {
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 10)
        return 'happy.glb';
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 5) return 'good.glb';
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 2) return 'soso.glb';
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 1) return 'sad.glb';
      return 'good.glb';
    }

    String getAnimationName() {
      final count = viewModel.homeInfoState.ploggingMonthlyCount;

      if (count >= 10) return 'Animation.happy';
      if (count >= 5) return 'Animation.good';
      if (count >= 2) return 'Animation.soso';
      if (count >= 1) return 'Animation.sad';
      return 'Animation.anger';
    }

    return InkWell(
      child: Container(
        height: 350,
        width: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Obx(() => CustomModelViewer(
              animationToPlay: getAnimationName(),
              src: 'assets/animations/${getAnimationFile()}',
              backgroundColor: Colors.white,
              autoRotateDelay: 0,
              autoRotate: true,
            )),
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.toNamed('/legacy'),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}