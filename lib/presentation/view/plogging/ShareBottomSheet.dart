import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:social_share/social_share.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void shareToInstagramStory(File screenshotFile) async {
  try {
    final platform = MethodChannel('com.example.share/instagram');
    final result = await platform.invokeMethod('shareInstagramStory', {
      'imagePath': screenshotFile.path,
      'backgroundTopColor': '#ffffff',
      'backgroundBottomColor': '#000000',
      'attributionURL': 'https://www.yourwebsite.com',
    });

    print('Instagram Story shared: $result');
  } catch (error) {
    print('Error sharing to Instagram Story: $error');
  }
}

class ShareBottomSheet {
  static void showShareOptions({
    required BuildContext context,
    required File screenshotFile,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '공유 옵션',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareButton(
                    iconPath: 'assets/images/shares/plogging/share_kakao_icon.png',
                    label: '카카오톡',
                    onTap: () {
                      Navigator.pop(context);
                      _shareKakao(screenshotFile);
                    },
                  ),
                  _buildShareButton(
                    iconPath: 'assets/images/shares/plogging/share_instagram_icon.png',
                    label: '인스타그램',
                    onTap: () {
                      print('here');
                      _shareInstagram(screenshotFile);
                    },
                  ),
                  _buildShareButton(
                    iconPath: 'assets/images/shares/plogging/share_thread_icon.png',
                    label: '스레드',
                    onTap: () {
                      Navigator.pop(context);
                      _shareDefault(screenshotFile);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildShareButton({
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static void _shareKakao(File screenshotFile) async {
    try {
      // Kakao 공유 로직
      final template = FeedTemplate(
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

      bool isKakaoTalkAvailable =
      await ShareClient.instance.isKakaoTalkSharingAvailable();
      if (isKakaoTalkAvailable) {
        Uri uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
      } else {
        Uri shareUrl =
        await WebSharerClient.instance.makeDefaultUrl(template: template);
        await launchBrowserTab(shareUrl, popupOpen: true);
      }
    } catch (error) {
      Get.snackbar('오류', '카카오톡 공유 중 문제가 발생했습니다: $error');
    }
  }

  static void _shareInstagram(File screenshotFile) {
    print('Instagram sharing started...');
    print('Image path: ${screenshotFile.path}');
    try {
      SocialShare.shareInstagramStory(
        appId: 'com.tople.toplearth',
        imagePath: screenshotFile.path,
      );
      print('Instagram sharing completed.');
    } catch (error) {
      print('Instagram sharing failed: $error');
    }
  }


  static void _shareDefault(File screenshotFile) {
    SocialShare.shareOptions(
      "플로깅 결과를 공유합니다!",
      imagePath: screenshotFile.path,
    );
  }
}
