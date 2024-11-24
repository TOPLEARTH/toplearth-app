import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

class GroupCodeInviteDialog extends StatelessWidget {
  final String groupName;
  final String groupCode;
  final String inviterName;

  const GroupCodeInviteDialog({
    Key? key,
    required this.groupName,
    required this.groupCode,
    required this.inviterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Row(
            children: [
              PngImageView(
                assetPath: 'assets/images/shares/share_earth_icon.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$groupName 그룹으로 초대해요!',
                      style: FontSystem.Sub1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorSystem.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '초대 by. $inviterName',
                      style: FontSystem.Sub2.copyWith(
                        color: ColorSystem.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  color: ColorSystem.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Group Code Section
          Text(
            '그룹 코드',
            style: FontSystem.Sub1.copyWith(color: ColorSystem.grey[700]),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: ColorSystem.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorSystem.grey[300]!),
                  ),
                  child: Text(
                    groupCode,
                    style: FontSystem.H3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorSystem.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: groupCode));
                  Get.snackbar('복사 완료', '그룹 코드가 복사되었습니다!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSystem.main,
                  minimumSize: const Size(50, 48),
                ),
                child: const Icon(Icons.copy, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Share Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  PngImageView(
                    assetPath: 'assets/images/shares/share_kakao_icon.png',
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '카카오톡 공유',
                    style: FontSystem.Sub3.copyWith(color: ColorSystem.black),
                  ),
                ],
              ),
              Column(
                children: [
                  PngImageView(
                    assetPath: 'assets/images/shares/share_link_icon.png',
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '링크 복사',
                    style: FontSystem.Sub3.copyWith(color: ColorSystem.black),
                  ),
                ],
              ),
              Column(
                children: [
                  PngImageView(
                    assetPath: 'assets/images/shares/share_etc_icon.png',
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '더보기',
                    style: FontSystem.Sub3.copyWith(color: ColorSystem.black),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
