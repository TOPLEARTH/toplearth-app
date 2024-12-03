import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/date_time_util.dart';
import 'package:toplearth/presentation/view/matching/widget/plogging_preview_widget.dart';
import 'package:toplearth/presentation/view/root/SharedProgressBar.dart';
import 'package:toplearth/presentation/view/root/matching_view_controller.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/plogging/naver_map_component.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/team_member_activity_card.dart';

class PloggingViewController extends GetxController {
  RxDouble teamAProgress = 0.5.obs;
  RxDouble teamBProgress = 0.5.obs;
  Timer? _timer;

  void startAnimation() {
    double targetProgress = 0.4; // 목표 비율
    bool isIncreasing = false; // 증가/감소 방향 플래그

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      // 현재 상태에 따라 progress 업데이트
      if (isIncreasing) {
        teamAProgress.value += 0.01;
        teamBProgress.value -= 0.01;
      } else {
        teamAProgress.value -= 0.01;
        teamBProgress.value += 0.01;
      }

      // 목표 비율에 도달하면 방향 전환
      if (teamAProgress.value <= targetProgress || teamAProgress.value >= 0.6) {
        isIncreasing = !isIncreasing; // 방향 전환
      }
    });
  }

  Future<void> _animateProgress(
      double teamA, double teamB, int duration) async {
    final int steps = 20; // 애니메이션 단계 수
    final double stepA = (teamA - teamAProgress.value) / steps;
    final double stepB = (teamB - teamBProgress.value) / steps;

    for (int i = 0; i < steps; i++) {
      await Future.delayed(Duration(milliseconds: duration ~/ steps), () {
        teamAProgress.value += stepA;
        teamBProgress.value += stepB;
      });
    }
  }

  String formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class WidgetBuildPloggingView extends StatelessWidget {
  final PloggingViewController controller = Get.put(PloggingViewController());
  final RootViewModel viewModel = Get.find<RootViewModel>();

  @override
  Widget build(BuildContext context) {
    print(viewModel.teamInfoState.value.teamMembers?.first.isActive);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '${viewModel.matchingRealTimeInfoState.ourTeamName}팀은 현재 \n 열심히 플로깅 중이에요!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 16),
        // Match Info Container
        Obx(() {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7389A9), // 백그라운드 색상 변경
              border: Border.all(
                color: const Color(0xFFD9D9D9),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${DateTimeUtil.convertFromDateTimeToKoreanWithoutMinute(viewModel.matchingRealTimeInfoState.matchingStartedAt!)} 플로깅 🥊',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // 글자 색상을 흰색으로 변경
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '🍃${viewModel.matchingRealTimeInfoState.ourTeamName} VS 🌱${viewModel.matchingRealTimeInfoState.opponentTeamName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // 글자 색상을 흰색으로 변경
                  ),
                ),
              ],
            ),
          );
        }),

        // Countdown Timer
        Obx(
          () {
            final timerController = Get.find<MatchedViewController>();
            return Center(
              child: Text(
                '${timerController.formatTime(timerController.countdownTime.value)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 흰색 글씨
                ),
              ),
            );
          },
        ),
        // Animated Progress Bar
        Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🍃${viewModel.matchingRealTimeInfoState.ourTeamName}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '🌱${viewModel.matchingRealTimeInfoState.opponentTeamName}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFCCCCCC),
                    ),
                  ),
                  CustomSharedProgressBar(
                    teamAProgress: controller.teamAProgress.value,
                    teamBProgress: controller.teamBProgress.value,
                    height: 30.0,
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Team Activity Section
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  '실시간 팀원 활동',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children:
                    viewModel.teamInfoState.value.teamMembers!.map((member) {
                  return TeamMemberActivityCard(
                    name: member.name ?? '이름 없음',
                    distance: member.distance ?? 0.0,
                    isActive: true,
                    isPlogging: true,
                  );
                }).toList(),
              ),
              const PreviewPloggingMap(),
              SizedBox(height: 16),
              RoundedRectangleTextButton(
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
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSharedProgressBar extends StatelessWidget {
  final double teamAProgress;
  final double teamBProgress;
  final double height;

  const CustomSharedProgressBar({
    Key? key,
    required this.teamAProgress,
    required this.teamBProgress,
    this.height = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: [
          // Team A Progress
          Expanded(
            flex: (teamAProgress * 100).toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F2A4F),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(height / 2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${(teamAProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          // Team B Progress
          Expanded(
            flex: (teamBProgress * 100).toInt(),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '${(teamBProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
