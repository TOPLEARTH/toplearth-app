import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';
import 'package:screenshot/screenshot.dart';

class PloggingScreen extends BaseScreen<PloggingViewModel> {
  const PloggingScreen({super.key});

  /// Screenshot 사용 활성화
  @override
  bool get needsScreenshot => true;

  @override
  ScreenshotController getScreenshotController() {
    return viewModel.screenshotController;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(() => Text(
            viewModel.isTracking.value
                ? "플로깅중이에용 ${viewModel.ploggingTime.value.inSeconds}초"
                : "플로깅",
          )),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          NaverMap(
            onMapReady: viewModel.onMapReady,
          ),
          Positioned(
            right: 16,
            bottom: 150,
            child: _buildFloatingActionButton(context),
          ),
        ],
      ),
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'zoom_in_plogging_screen',
          onPressed: () => viewModel.moveToCurrentLocation(),
          backgroundColor: viewModel.isFollowingLocation.value
              ? ColorSystem.main
              : Colors.grey,
          child: const Icon(Icons.location_on),
        ),
        FloatingActionButton(
          heroTag: 'zoom_out_plogging_screen',
          onPressed: () => viewModel.toggleTrashBins(),
          backgroundColor:
              viewModel.showTrashBins.value ? ColorSystem.main : Colors.grey,
          child: Icon(viewModel.showTrashBins.value
              ? Icons.delete_outline
              : Icons.delete_outline_outlined),
        ),
        FloatingActionButton(
          heroTag: "add_marker_plogging_screen",
          onPressed: () => viewModel.addMarkerAtCurrentLocation(),
          backgroundColor: ColorSystem.main,
          child: const Icon(Icons.add_location),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: viewModel.isTracking.value
              ? () => viewModel.stopPlogging()
              : () => viewModel.startIndividualPlogging(),
          label: Text(
              viewModel.isTracking.value ? "Stop Plogging" : "Start Plogging"),
          icon:
              Icon(viewModel.isTracking.value ? Icons.stop : Icons.play_arrow),
        ),
        const SizedBox(height: 10),
        // 이미지 선택 및 업로드 버튼 추가
        FloatingActionButton.extended(
          heroTag: "upload_image_plogging_screen",
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              // 이미지 선택 처리
              viewModel.setSelectedImage(File(pickedFile.path));
              // 업로드 로직
              final result =
                  await viewModel.uploadImage(37.5665, 126.9780); // 예시 좌표
              if (result.success) {
                Get.snackbar('성공', result.message ?? '이미지 업로드에 성공했습니다.');
              } else {
                Get.snackbar('실패', result.message ?? '이미지 업로드에 실패했습니다.');
              }
            }
          },
          label: const Text('이미지 업로드'),
          icon: const Icon(Icons.upload_file),
          backgroundColor: ColorSystem.main,
        ),
        FloatingActionButton.extended(
          heroTag: "finish_image_plogging_screen",
          onPressed: () async {
            final result = await viewModel.finishPlogging();

            if (result.success) {
              Get.snackbar('성공', result.message ?? '플로깅을 성공적으로 마쳤습니다.');
            } else {
              Get.snackbar('실패', result.message ?? '플로깅을 마치는데 실패했습니다.');
            }
          },
          label: const Text('플로깅 끝내기'),
          icon: const Icon(Icons.upload_file),
          backgroundColor: ColorSystem.main,
        ),
        const SizedBox(height: 10),
        // 이미지 라벨링 버튼 추가
        FloatingActionButton.extended(
          heroTag: "label_image_plogging_screen",
          onPressed: () async {
            // 라벨링 로직 실행
            final result = await viewModel.labelingPloggingImages();
            if (result.success) {
              Get.snackbar('성공', result.message ?? '이미지 라벨링에 성공했습니다.');
            } else {
              Get.snackbar('실패', result.message ?? '이미지 라벨링에 실패했습니다.');
            }
          },
          label: const Text('이미지 라벨링'),
          icon: const Icon(Icons.label),
          backgroundColor: ColorSystem.main,
        ),

        FloatingActionButton.extended(
          heroTag: "capture_screen_plogging_screen",
          onPressed: () async {
            try {
              // 캡처된 이미지를 File로 저장
              final directory = (await getApplicationDocumentsDirectory())
                  .path; // path_provider 패키지에서 경로 얻기
              String fileName =
                  '${DateTime.now().microsecondsSinceEpoch}.png'; // 파일 이름에 현재 시간을 기반으로 한 유니크한 값을 추가
              String fullPath = '$directory/$fileName'; // 전체 파일 경로 생성

              // 스크린샷 캡처 및 지정된 경로에 파일 저장
              await viewModel.screenshotController
                  .captureAndSave(directory, fileName: fileName // 파일 이름
                      );

              print('Screenshot saved to $fullPath');

              final XFile file = XFile(fullPath);

              viewModel.ploggingImage.value = File(file.path);

              Get.snackbar('성공', '화면 캡처가 완료되었습니다.');
            } catch (e) {
              Get.snackbar('오류', '캡처 중 오류 발생: $e');
            }
          },
          label: const Text('화면 캡처'),
          icon: const Icon(Icons.camera_alt),
          backgroundColor: ColorSystem.main,
        ),
      ],
    );
  }
}
