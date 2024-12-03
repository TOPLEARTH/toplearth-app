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
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/plogging_labeling_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/presentation/view/matching/MapControllerManager.dart';
import 'package:toplearth/presentation/view/plogging/ShareBottomSheet.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/plogging/naver_map_component.dart';
import 'package:flutter/rendering.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/plogging_share_dialog.dart';

class PloggingShareScreen extends BaseScreen<PloggingViewModel> {
  late final List<int> imageIds;
  late final List<String> labels;
  final PloggingViewModel viewModel =
      Get.put(PloggingViewModel()); // ViewModel 초기화

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
                  NaverMapComponent(), // 지도 컴포넌트
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
            child: Column(
              children: [
                // 공유하기 버튼
                RoundedRectangleTextButton(
                  backgroundColor: ColorSystem.main,
                  width: double.infinity,
                  onPressed: () async {
                    final screenshotFile = await _processScreenshots();
                    if (screenshotFile != null) {
                      // 바텀시트 호출
                      Get.bottomSheet(
                        PloggingShareDialog(screenshotFile: screenshotFile),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      );
                    }
                  },
                  text: '이미지 공유하기',
                ),
                const SizedBox(height: 12), // 버튼 간 간격 추가
                // 홈으로 이동하기 버튼
                RoundedRectangleTextButton(
                  backgroundColor: ColorSystem.main,
                  width: double.infinity,
                  onPressed: () async {
                    final screenshotFile = await _processScreenshots();
                    if (screenshotFile != null) {
                      final result = await labelingPloggingImages(
                        imageIds,
                        labels,
                        screenshotFile,
                      );
                      if (result.success) {
                        final matchingGroupVM = Get.find<MatchingGroupViewModel>();
                        final rootVM = Get.find<RootViewModel>();

                        matchingGroupVM.setMatchingStatus(EMatchingStatus.DEFAULT); // 상태 변경
                        rootVM.matchingStatusState.value = MatchingStatusState(
                          status: EMatchingStatus.DEFAULT, // 상태 초기화
                        );
                        Get.offAllNamed(AppRoutes.ROOT);
                      } else {

                      }
                    }
                  },
                  text: '홈으로 이동하기',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<File?> _processScreenshots() async {
    try {
      // Flutter UI 스크린샷 캡처
      final flutterScreenshot =
          await viewModel.screenshotController.capture(pixelRatio: 1.5);
      if (flutterScreenshot == null) {
        return null;
      }

      // 캡처한 스크린샷 데이터를 파일로 저장
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(flutterScreenshot);

      return file; // 파일 반환
    } catch (e) {
      return null;
    }
  }

  Future<ResultWrapper> labelingPloggingImages(
    List<int> imageIds,
    List<String> labels,
    File screenshotFile,
  ) async {
    if (imageIds.isEmpty ||
        labels.isEmpty ||
        imageIds.length != labels.length) {
      return ResultWrapper(
        success: false,
        message: '이미지 ID와 라벨 리스트가 유효하지 않거나 크기가 일치하지 않습니다.',
      );
    }

    try {
      final state = await viewModel.labelingPloggingImages(
          imageIds, labels, screenshotFile);

      if (!state.success) {
        return ResultWrapper(
          success: false,
          message: state.message,
        );
      }

      return ResultWrapper(
        success: true,
        message: '라벨링 및 스크린샷 저장이 성공적으로 처리되었습니다.',
      );
    } catch (e) {
      return ResultWrapper(
        success: false,
        message: '처리 중 오류 발생: $e',
      );
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
                '거리', '${viewModel.distance.toStringAsFixed(3)} km'),
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
