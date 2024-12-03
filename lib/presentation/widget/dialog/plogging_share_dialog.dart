import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:social_share/social_share.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

class PloggingShareDialog extends StatelessWidget {
  final File screenshotFile;

  const PloggingShareDialog({
    Key? key,
    required this.screenshotFile,
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
                child: Text(
                  '플로깅을 공유해보세요!',
                  style: FontSystem.Sub1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorSystem.black,
                  ),
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
          // Share Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareButton(
                iconPath: 'assets/images/shares/plogging/share_kakao_icon.png',
                label: '카카오톡',
                onTap: () => _shareKakao(),
              ),
              _buildShareButton(
                iconPath: 'assets/images/shares/plogging/share_instagram_icon.png',
                label: '인스타그램',
                onTap: () => _shareInstagram(),
              ),
              _buildShareButton(
                iconPath: 'assets/images/shares/plogging/share_thread_icon.png',
                label: '스레드',
                onTap: () => _shareDefault(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          PngImageView(
            assetPath: iconPath,
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: FontSystem.Sub3.copyWith(color: ColorSystem.black),
          ),
        ],
      ),
    );
  }

  void _shareKakao() async {
    try {
      // Create a custom Kakao message template
      FeedTemplate template = FeedTemplate(
        content: Content(
          title: '플로깅 결과를 공유합니다!',
          description: '저와 함께 플로깅에 참여하세요!',
          imageUrl: Uri.file(screenshotFile.path),
          link: Link(
            webUrl: Uri.parse('https://www.yourwebsite.com'),
            mobileWebUrl: Uri.parse('https://www.yourwebsite.com'),
          ),
        ),
        buttons: [
          Button(
            title: '웹에서 보기',
            link: Link(
              webUrl: Uri.parse('https://www.yourwebsite.com'),
              mobileWebUrl: Uri.parse('https://www.yourwebsite.com'),
            ),
          ),
        ],
      );

      // Check if KakaoTalk is installed and share
      bool isKakaoTalkAvailable =
          await ShareClient.instance.isKakaoTalkSharingAvailable();
      if (isKakaoTalkAvailable) {
        Uri uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } else {
        Uri shareUrl =
            await WebSharerClient.instance.makeDefaultUrl(template: template);
        await launchBrowserTab(shareUrl, popupOpen: true);
      }
    } catch (error) {
      Get.snackbar('오류', '카카오톡 공유 중 문제가 발생했습니다: $error');
    }
  }

  void _shareInstagram() {
    SocialShare.shareInstagramStory(
      appId: 'com.tople.toplearth',
      imagePath: screenshotFile.path,
    );
  }

  void _shareDefault() {
    SocialShare.shareOptions(
      "플로깅 결과를 공유합니다!",
      imagePath: screenshotFile.path,
    );
  }
}
