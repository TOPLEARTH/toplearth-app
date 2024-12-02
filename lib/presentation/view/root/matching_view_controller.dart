import 'dart:async';
import 'package:get/get.dart';

class MatchedViewController extends GetxController {
  // Timer
  Rx<Duration> countdownTime = const Duration(hours: 1, minutes: 30).obs;
  Timer? _timer;

  // Progress Bar Data (Dynamic Updates via Socket)
  RxDouble teamAProgress = 50.0.obs;
  RxDouble teamBProgress = 50.0.obs;

  // Team Member Activity
  RxList<Map<String, dynamic>> members = [
    {'name': '김무로', 'progress': 5.2, 'isActive': true, 'statusText': ''},
    {'name': '김신공', 'progress': 10.2, 'isActive': true, 'statusText': ''},
    {'name': '김동국', 'progress': 0.0, 'isActive': false, 'statusText': '현재 플로깅을 쉬고 있어요'},
    {'name': '김경희', 'progress': 0.0, 'isActive': false, 'statusText': '현재 플로깅을 쉬고 있어요'},
  ].obs;

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdownTime.value.inSeconds > 0) {
        countdownTime.value -= const Duration(seconds: 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    startCountdown();
    // Simulate dynamic progress updates (Replace with actual socket logic)
    Timer.periodic(const Duration(seconds: 5), (_) {
      teamAProgress.value = (teamAProgress.value + 5) % 100;
      teamBProgress.value = (teamBProgress.value + 3) % 100;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
