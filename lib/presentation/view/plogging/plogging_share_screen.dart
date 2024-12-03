import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/plogging/naver_map_component.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/plogging_share_dialog.dart';

Future<String?> getApplicationDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File?> combineImages(Uint8List flutterImage, Uint8List mapImage) async {
  try {
    // Decode the images
    final flutterDecoded = await decodeImageFromList(flutterImage);
    final mapDecoded = await decodeImageFromList(mapImage);

    // Create a canvas to combine the images
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the map image
    canvas.drawImage(mapDecoded, Offset(0, 0), Paint());

    // Draw the Flutter UI image below the map image
    final flutterImageOffset = Offset(0, mapDecoded.height.toDouble());
    canvas.drawImage(flutterDecoded, flutterImageOffset, Paint());

    // Convert the combined image to bytes
    final picture = recorder.endRecording();
    final image = await picture.toImage(
        mapDecoded.width,
        mapDecoded.height + flutterDecoded.height); // Combined height of both images
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    if (byteData == null) return null;

    // Save to file
    final directory = await getApplicationDocumentsPath();
    if (directory == null) return null;
    final filePath =
        '$directory/combined_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  } catch (e) {
    debugPrint('Error combining images: $e');
    return null;
  }
}

class PloggingShareScreen extends BaseScreen<PloggingViewModel> {
  late final List<int> imageIds;
  late final List<String> labels;

  PloggingShareScreen({Key? key}) : super(key: key) {
    final arguments = Get.arguments ?? {};
    imageIds = arguments['imageIds'] ?? [];
    labels = arguments['labels'] ?? [];
  }

  @override
  Widget buildBody(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('Received imageIds: $imageIds');
      print('Received labels: $labels');

      // Process screenshots
      final screenshotFile = await _processScreenshots();

      if (screenshotFile != null) {
        // Show the share dialog
        Get.bottomSheet(
          PloggingShareDialog(screenshotFile: screenshotFile),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        );
      }
    });

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
                  NaverMapComponent(), // Make sure NaverMapComponent exposes a controller
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
            child: RoundedRectangleTextButton(
              width: double.infinity,
              onPressed: () {
                Get.offAllNamed(AppRoutes.ROOT);
              },
              text: '홈으로 이동하기',
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> _processScreenshots() async {
    try {
      // Capture Flutter screenshot
      final flutterScreenshot =
      await viewModel.screenshotController.capture(pixelRatio: 1.5);
      if (flutterScreenshot == null) {
        Get.snackbar('오류', 'Flutter UI 스크린샷 캡처에 실패했습니다.');
        return null;
      }

      // Capture map screenshot using NaverMapController
      final mapScreenshot = await viewModel.screenshotController.capture();
      if (mapScreenshot == null) {
        Get.snackbar('오류', '지도 스크린샷 캡처에 실패했습니다.');
        return null;
      }

      // Combine screenshots
      final combinedScreenshotFile =
      await combineImages(flutterScreenshot, mapScreenshot);
      return combinedScreenshotFile;
    } catch (e) {
      Get.snackbar('오류', '스크린샷 처리 중 문제가 발생했습니다: $e');
      return null;
    }
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
