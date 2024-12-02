import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/plogging/naver_map_component.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

Future<String?> getApplicationDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String?> captureScreenshot(
    String directory, ScreenshotController controller) async {
  try {
    final fileName = '${DateTime.now().microsecondsSinceEpoch}.png';
    final fullPath = '$directory/$fileName';
    await controller.captureAndSave(directory,
        fileName: fileName); // Pass the correct file name
    return fullPath;
  } catch (e) {
    debugPrint('Error capturing screenshot: $e');
    return null;
  }
}

class PloggingShareScreen extends BaseScreen<PloggingViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('플로깅 공유'),
        backgroundColor: ColorSystem.main,
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: viewModel.screenshotController,
              child: Stack(
                children: [
                  NaverMapComponent(),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: _buildSummaryCard(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  // Step 1: Get the application documents path
                  final directory = await getApplicationDocumentsPath();
                  if (directory != null) {
                    // Step 2: Capture screenshot and save to file
                    final screenshotPath = await captureScreenshot(
                      directory,
                      viewModel.screenshotController,
                    );

                    if (screenshotPath != null) {
                      // Step 3: Show success message for screenshot capture
                      Get.snackbar(
                          '성공', '스크린샷이 성공적으로 저장되었습니다: $screenshotPath');

                      // Step 4: Convert screenshot path to File
                      final screenshotFile = File(screenshotPath);

                      // Step 5: Call labelingPloggingImages with dummy data
                      // Replace this with actual IDs and labels
                      final List<int> imageIds = [
                        1,
                        2,
                        3
                      ]; // Replace with real IDs
                      final List<String> labels = [
                        'CAN',
                        'PLASTIC',
                        'PAPER'
                      ]; // Replace with real labels

                      final result = await viewModel.labelingPloggingImages(
                          imageIds, labels, screenshotFile);

                      if (result.success) {
                        Get.snackbar('성공', '라벨링이 성공적으로 완료되었습니다!');
                        // Optionally navigate to the next screen or share logic here
                      } else {
                        Get.snackbar(
                            '실패', result.message ?? '라벨링 중 문제가 발생했습니다.');
                      }
                    } else {
                      Get.snackbar('오류', '스크린샷 저장에 실패했습니다.');
                    }
                  }
                } catch (e) {
                  // Step 6: Handle any errors during the process
                  Get.snackbar('오류', '공유 중 문제가 발생했습니다: $e');
                }
              },
              child: const Text('공유하기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '플로깅 결과',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
                '거리', '${viewModel.distance.toStringAsFixed(1)} km'),
            _buildSummaryRow(
                '시간', _formatDuration(viewModel.ploggingTime.value)),
            _buildSummaryRow('수거한 쓰레기', '${viewModel.pickUpCnt}개'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
