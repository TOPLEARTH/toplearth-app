import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';

class ToggleSectionView extends StatelessWidget {
  const ToggleSectionView({
    super.key,
    required this.title,
    required this.content,
    required this.isEnable,
    required this.onToggle,
  });

  final String title;
  final String content;
  final bool isEnable;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontSystem.H6,
              ),
              Text(
                content,
                style: FontSystem.Sub3.copyWith(
                  color: ColorSystem.neutral.shade500,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 24,
            child: Switch(
              value: isEnable,
              onChanged: onToggle,
              activeColor: ColorSystem.white,
              activeTrackColor: ColorSystem.primary.shade600,
              inactiveThumbColor: ColorSystem.white,
              inactiveTrackColor: ColorSystem.neutral.shade300,
              trackOutlineColor: WidgetStateProperty.all(
                ColorSystem.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
