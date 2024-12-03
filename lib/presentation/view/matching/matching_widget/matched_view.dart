import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/hour_util.dart';
import 'package:toplearth/presentation/view/root/SharedProgressBar.dart';
import 'package:toplearth/presentation/view/root/matching_view_controller.dart';
import 'package:toplearth/presentation/widget/team_member_activity_card.dart';

class MatchedView extends StatelessWidget {
  final MatchedViewController controller = Get.put(MatchedViewController());
  final nextHour = getNextHour();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '얼쑤얼쑤 팀과 $nextHour 시에\n플로깅 대전이 매칭되었어요!',
          style: FontSystem.H1.copyWith(color: Colors.black),
        ),
        // Match Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white, // White background inside
            border: Border.all(
              color: const Color(0xFFD9D9D9), // Border color
              width: 2, // Border width
            ),
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Column(
            children: [
              Text(
                '2024.10.23 7시 플로깅 🌍',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '얼쑤얼쑤 🌱 VS 디지유 🌿',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            )),
        const SizedBox(height: 16),
        // Shared Progress Bar
        Obx(() => SharedProgressBar(
              teamAProgress: controller.teamAProgress.value / 100,
              teamBProgress: controller.teamBProgress.value / 100,
              height: 24.0,
            )),
        const SizedBox(height: 32),

        // Team Activity Section
        const Text(
          '실시간 팀원 활동',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
              children: controller.members.map((member) {
                return TeamMemberActivityCard(
                  name: member['name'] as String,
                  progress: member['progress'] as double,
                  isActive: member['isActive'] as bool,
                  statusText: member['statusText'] as String,
                );
              }).toList(),
            )),
      ],
    );
  }
}
