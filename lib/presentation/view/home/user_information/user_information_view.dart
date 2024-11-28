import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view/home/user_information/user_progress_bar.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class HomeUserInfoView extends BaseWidget<RootViewModel> {
  const HomeUserInfoView({super.key});

  @override
  Widget buildView(BuildContext context) {
    // 뷰모델 데이터
    final String userName = viewModel.userState.nickname;

    // final int joinedTime;
    // final int ploggingMonthlyCount;
    // final int ploggingMonthlyDuration;

    final int joinedTime = viewModel.homeInfoState.joinedTime;
    final int ploggingMonthlyCount =
        viewModel.homeInfoState.ploggingMonthlyCount;
    final int ploggingMonthlyDuration =
        viewModel.homeInfoState.ploggingMonthlyDuration;
    final double totalKilometers = viewModel.userState.totalKilometers;
    final double targetKilometers = viewModel.userState.targetKilometers;

    // final int daysTogether = viewModel.userState.;
    // final double currentProgress = viewModel.userState.currentProgress;
    // final int lastWeekSessions = viewModel.userState.lastWeekSessions;
    // final int lastWeekDuration = viewModel.userState.lastWeekDuration;
    // final int lastWeekCalories = viewModel.userState.lastWeekCalories;
    double calculateProgress(double totalKilometers, double targetKilometers) {
      if (targetKilometers == 0) {
        return 0.0; // 목표 거리가 0일 경우 진행률은 0%
      }
      return totalKilometers / targetKilometers;
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 텍스트
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${viewModel.userState.nickname}님과 플로깅 동행\n${viewModel.homeInfoState.joinedTime} 일째',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('주간 목표'),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  print('목표 설정하기 tapped');
                },
                child: const Text(
                  '목표 설정하기',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ProgressBar 컴포넌트

          UserProgressBar(
            progress: calculateProgress(viewModel.userState.totalKilometers,
                viewModel.userState.targetKilometers), // 진행률
            height: 10, // 높이
            backgroundColor: const Color(0xFFE0E0E0),
            progressColor: const Color(0xFF0F2A4F),
          ),
          const SizedBox(height: 8),
          // 거리 텍스트
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('현재 ${viewModel.userState.totalKilometers} KM'),
              Text('${viewModel.userState.targetKilometers} KM',
                  style: const TextStyle(color: ColorSystem.main)),
            ],
          ),
          const SizedBox(height: 16),
          // 지난 주 플로깅 결산
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '$ploggingMonthlyCount 회',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('지난주 플로깅 횟수'),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${viewModel.homeInfoState.ploggingMonthlyDuration ~/ 60} 시간',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('지난주 플로깅 시간'),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${viewModel.homeInfoState.burnedCalories} kcal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('지난주 소모 칼로리'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
