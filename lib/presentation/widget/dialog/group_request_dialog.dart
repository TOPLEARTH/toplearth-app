import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';

class GroupRequestDialog extends StatelessWidget {
  const GroupRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Get.width * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '그룹이 필요해요 🌏',
              style: FontSystem.H2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '플로깅 대결은 그룹이 필요합니다!',
              style: FontSystem.Sub2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            RoundedRectangleTextButton(
              text: '그룹 생성하기 🌏',
              textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
              backgroundColor: ColorSystem.main,
              onPressed: () {
                Get.toNamed(AppRoutes.GROUP_CREATE);
              },
            ),
            const SizedBox(height: 8),
            RoundedRectangleTextButton(
              text: '그룹 검색하기 🌏',
              textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
              backgroundColor: ColorSystem.main,
              onPressed: () {
                Get.toNamed(AppRoutes.GROUP_SEARCH);
              },
            ),
            const SizedBox(height: 8),
            RoundedRectangleTextButton(
              text: '나중에 할래요!',
              textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
              backgroundColor: ColorSystem.secondary,
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
