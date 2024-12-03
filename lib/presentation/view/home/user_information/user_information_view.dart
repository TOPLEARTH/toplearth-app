import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view/home/user_information/user_progress_bar.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';

class HomeUserInfoView extends BaseWidget<HomeViewModel> {
  const HomeUserInfoView({super.key});

  @override
  Widget buildView(BuildContext context) {
    double calculateProgress(double totalKilometers, double targetKilometers) {
      if (targetKilometers == 0) {
        return 0.0;
      }
      return totalKilometers / targetKilometers;
    }

    void showTargetInputDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DistanceDialog(context);
        },
      );
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                onTap: () => showTargetInputDialog(context),
                child: const Text(
                  '목표 설정하기',
                  style: TextStyle(
                    color: ColorSystem.sub,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          UserProgressBar(
            progress: calculateProgress(viewModel.userState.totalKilometers,
                viewModel.userState.targetKilometers),
            height: 10,
            backgroundColor: const Color(0xFFE0E0E0),
            progressColor: const Color(0xFF0F2A4F),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('현재 ${viewModel.userState.totalKilometers} KM'),
              Text('${viewModel.userState.targetKilometers} KM',
                  style: const TextStyle(color: ColorSystem.main)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${viewModel.homeInfoState.ploggingMonthlyCount} 회',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('지난달 플로깅 횟수'),
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
                  const Text('지난달 플로깅 시간'),
                ],
              ),
              Column(
                children: [
                  Text('${viewModel.homeInfoState.burnedCalories} kcal',
                      style: FontSystem.H4),
                  const Text('지난달 소모 칼로리'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget DistanceDialog(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('목표 설정하기'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "목표 KM 입력",
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: ColorSystem.main),
          hintStyle: TextStyle(color: ColorSystem.main),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            final input = double.tryParse(controller.text);
            if (input != null) {
              viewModel.setGoalDistance(input);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
