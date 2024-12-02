import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/utility/log_util.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';
import 'package:toplearth/presentation/widget/image/svg_image_view.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isOnlyNeedCenterLogo;

  const DefaultAppBar({
    super.key,
    this.isOnlyNeedCenterLogo = false,
  });

  static const String _centerLogoPath = 'assets/images/toplearth_text_logo.png';
  static const String _alarmIconPath = 'assets/icons/alarm_off.svg';
  static const String _settingsIconPath = 'assets/icons/setting.svg';

  @override
  Widget build(BuildContext context) {
    if (isOnlyNeedCenterLogo) {
      // 중앙 로고만 표시
      return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: PngImageView(
          assetPath: _centerLogoPath,
          height: 70, // Unified height with DefaultBackAppBar
          margin: const EdgeInsets.only(left: 25), // Consistent margin
        ),
      );
    }

    // 기본 AppBar
    return SafeArea(
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Center(
                child: PngImageView(
                  assetPath: _centerLogoPath,
                  height: 70, // Unified height
                  margin: EdgeInsets.only(left: 25), // Consistent margin
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    LogUtil.info('Alarm button tapped');
                    // Get.toNamed(AppRoutes.APP_ALARM); // 알림 화면 이동
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SvgImageView(
                      assetPath: _alarmIconPath,
                      height: 25,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // finishMatching
                    Get.find<MatchingGroupViewModel>().finishVsMatching(20,  200, 300, true);
                    // Get.toNamed(AppRoutes.TEST_CODE);
                    LogUtil.info('Setting button tapped');
                    // Get.toNamed(AppRoutes.APP_SETTING); // 알림 화면 이동
                  },
                  child: const SvgImageView(
                    assetPath: _settingsIconPath,
                    height: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0); // Unified height
}
