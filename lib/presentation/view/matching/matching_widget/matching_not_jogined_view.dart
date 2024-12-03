import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/group_request_dialog.dart';

Widget _buildNotJoinedView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '그룹 대항전에 참가하기 위해서는\n그룹에 소속되어 있어야 해요!',
        style: FontSystem.H1.copyWith(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      Image.asset(
        'assets/images/earth_matching.png',
        width: 400,
        height: 400,
        fit: BoxFit.contain,
      ),
      const SizedBox(height: 24),
      RoundedRectangleTextButton(
        text: '그룹 설정하기',
        backgroundColor: ColorSystem.main,
        borderRadius: 24,
        textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
        onPressed: () {
          Get.dialog(
            const GroupRequestDialog(),
          );
        },
      ),
    ],
  );
}