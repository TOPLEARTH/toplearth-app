import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/date_time_util.dart';
import 'package:toplearth/app/utility/hour_util.dart';
import 'package:toplearth/presentation/view/matching/widget/plogging_preview_widget.dart';
import 'package:toplearth/presentation/view/root/SharedProgressBar.dart';
import 'package:toplearth/presentation/view/root/matching_view_controller.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/team_member_activity_card.dart';

class MatchedView extends StatelessWidget {
  final MatchedViewController controller = Get.put(MatchedViewController());
  final RootViewModel viewModel = Get.find<RootViewModel>();
  final nextHour = getNextHour();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Bootstrap 로드 상태 확인
      if (!viewModel.isBootstrapLoaded.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // 팀 정보 상태 확인
      final teamInfoState = viewModel.teamInfoState.value;

      if (teamInfoState == null ||
          teamInfoState.teamMembers == null ||
          teamInfoState.teamMembers!.isEmpty) {
        return const Center(
          child: Text(
            '팀원이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      // 실시간 매칭 상태
      final realTimeInfoState = viewModel.matchingRealTimeInfoState;

      // Null-safe 값을 설정
      final ourTeamName = realTimeInfoState.ourTeamName ?? '우리 팀';
      final opponentTeamName = realTimeInfoState.opponentTeamName ?? '상대 팀';
      final matchingStartedAt = realTimeInfoState.matchingStartedAt;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$opponentTeamName 팀과 $nextHour 시에\n플로깅 대전이 매칭되었어요!',
            style: FontSystem.H1.copyWith(color: Colors.black),
          ),
          // Match Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFD9D9D9),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  matchingStartedAt != null
                      ? '${DateTimeUtil.convertFromDateTimeToKorean(matchingStartedAt)}시 플로깅 🌍'
                      : '플로깅 정보 없음',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '🍃$ourTeamName vs 🌱$opponentTeamName',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Countdown Timer
          Obx(() => Center(
                child: Text(
                  controller.formatTime(controller.countdownTime.value),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(height: 16),
          // Shared Progress Bar
          Obx(() => SharedProgressBar(
                teamAProgress: controller.teamAProgress.value / 100,
                teamBProgress: controller.teamBProgress.value / 100,
                height: 24.0,
                isFixed: true,
              )),
          const SizedBox(height: 32),
          Center(
            child: RoundedRectangleTextButton(
              text: '🥊 대결 플로깅 하러 가기 🥊',

              backgroundColor: Colors.white,
              textStyle: FontSystem.H3.copyWith(color: ColorSystem.main),
              borderRadius: 16.0,
              borderWidth: 0.7,
              borderColor: ColorSystem.main,
              onPressed: () {
                Get.toNamed(AppRoutes.PLOGGING);
              },
            ),
          ),
          SizedBox(height: 16),
          // Team Activity Section
          const Text(
            '실시간 팀원 활동',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: teamInfoState.teamMembers!.map((member) {
              return TeamMemberActivityCard(
                name: member.name ?? '이름 없음',
                distance: member.distance ?? 0.0,
                isActive: member.isActive ?? false,
              );
            }).toList(),
          ),
          const PreviewPloggingMap(),
        ],
      );
    });
  }
}
