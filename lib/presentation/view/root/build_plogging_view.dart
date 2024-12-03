import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';

class PloggingViewController extends GetxController {
  RxDouble teamAProgress = 0.5.obs;
  RxDouble teamBProgress = 0.5.obs;
  Timer? _timer;

  void startProgressAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      teamAProgress.value = (teamAProgress.value + 0.01) % 1.0;
      teamBProgress.value = 1.0 - teamAProgress.value;
    });
  }

  @override
  void onInit() {
    super.onInit();
    startProgressAnimation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class WidgetBuildPloggingView extends StatelessWidget {
  final PloggingViewController controller = Get.put(PloggingViewController());
  final MatchingGroupViewModel viewModel = Get.put(MatchingGroupViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          '존나\n플로깅 중이에요!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Match Info Container
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
                '2024.10.23 7시 플로깅 🌍',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${viewModel.teamInfoState.value.teamName} VS ${viewModel.opponentTeamName}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Countdown Timer
        Obx(
          () => Center(
            child: Text(
              viewModel.formatTime(viewModel.countdownTime.value),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Animated Progress Bar
        Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '얼쑤얼쑤',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '디지유',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFCCCCCC),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: controller.teamAProgress.value,
                    child: Container(
                      height: 24,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        color: Color(0xFF0F2A4F),
                      ),
                      child: Center(
                        child: Text(
                          '${(controller.teamAProgress.value * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
