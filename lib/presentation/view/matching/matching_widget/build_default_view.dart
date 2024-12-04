import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/hour_util.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view/matching/real_time_team_activity_section.dart';
import 'package:toplearth/presentation/view/matching/widget/matching_group_recent_plogging_widget.dart';
import 'package:toplearth/presentation/view/matching/widget/plogging_preview_widget.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';

/// DEFAULT View
class BuildDefaultView extends BaseWidget<MatchingGroupViewModel> {
  final nextHour = getNextHour();
  @override
  Widget buildView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${viewModel.teamInfoState.value.teamName}은 현재\n플로깅을 쉬고 있어요!',
          style: FontSystem.H1.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        RoundedRectangleTextButton(
          onPressed: () {
            viewModel.requestRandomMatching();
            // Get.snackbar('랜덤 매칭', '랜덤 매칭 요청이 실행되었습니다.');
          },
          text: '$nextHour 시 플로깅 랜덤매칭 하기',
          icon: Image.asset(
            'assets/images/matching_dice_image.png',
            width: 36,
            height: 36,
          ),
          backgroundColor: Colors.white,
          textStyle: FontSystem.H3.copyWith(color: ColorSystem.main),
          borderRadius: 16.0,
          borderWidth: 0.7,
          borderColor: ColorSystem.main,
        ),
        const SizedBox(height: 16),
        RoundedRectangleTextButton(
          text: '$nextHour 시 플로깅 지정매칭 하기',
          icon: Image.asset(
            'assets/images/matching_target_image.png',
            width: 36,
            height: 36,
          ),
          backgroundColor: Colors.white,
          textStyle: FontSystem.H3.copyWith(color: ColorSystem.main),
          borderRadius: 16.0,
          borderWidth: 0.7,
          borderColor: ColorSystem.main,
          onPressed: () {
            // Get.snackbar('지정 매칭', '지정 매칭 요청이 실행되었습니다.');
          },
        ),
        const SizedBox(height: 16),
        RealTimeTeamActivitySection(),
        const PreviewPloggingMap(),
        const RecentPloggingPreview(),
      ],
    );
  }
}
