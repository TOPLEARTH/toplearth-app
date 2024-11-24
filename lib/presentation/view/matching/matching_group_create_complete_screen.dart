import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/presentation/view_model/matching_group_complete/matching_group_create_complete_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/group_code_invite_dialog.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

class MatchingGroupCreateCompleteScreen
    extends BaseScreen<MatchingGroupCreateCompleteViewModel> {
  const MatchingGroupCreateCompleteScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    final GroupBriefState selectedGroup = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get bottom sheet with group details
      final groupName = viewModel.groupName;
      final groupCode = viewModel.groupCode;
      final inviterName = viewModel.inviterName;

      Get.bottomSheet(
        GroupCodeInviteDialog(
          groupName: groupName,
          groupCode: groupCode,
          inviterName: inviterName,
        ),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );
    });

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${viewModel.groupName} 가입 완료!',
                  style: FontSystem.H2.copyWith(
                    color: ColorSystem.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '이제 플로깅 대전을 즐길 수 있어요!',
                  style: FontSystem.Sub1.copyWith(
                    color: ColorSystem.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PngImageView(
                  assetPath: 'assets/images/earth_view.png', // Replace with actual asset path
                  height: 300,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RoundedRectangleTextButton(
              text: '홈으로 돌아가기',
              width: double.infinity,
              backgroundColor: ColorSystem.main,
              textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
              onPressed: () {
                Get.toNamed(AppRoutes.ROOT); // Navigate to home
              },
            ),
          ),
        ],
      ),
    );
  }
}
