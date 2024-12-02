import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view/plogging/request_permission.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class DraggableSheet extends BaseWidget<PloggingViewModel> {
  const DraggableSheet({super.key});

  @override
  Widget buildView(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: ColorSystem.main, // 배경색을 ColorSystem.main으로 설정
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildHandle(),
              const SizedBox(height: 16),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildImagePreview(),
              const SizedBox(height: 16),
              _buildActionButtons(),
              const SizedBox(height: 16),
              _buildPloggingButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '사진 촬영 및 업로드',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildImagePreview() {
    return Obx(() {
      if (viewModel.selectedImage.value != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            viewModel.selectedImage.value!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_gallery_image.png',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  "쓰레기 사진을 찍어주세요!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          label: '사진 찍기',
          icon: Icons.camera_alt,
          onTap: () async {
            await requestPermissions();
            final picker = ImagePicker();
            final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );

            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);
            if (photo != null) {
              viewModel.setSelectedImage(File(photo.path));
              await viewModel.addMarkerAtCurrentLocationWithCoordinates(
                position.latitude,
                position.longitude,
              );
              await viewModel.uploadImage(
                position.latitude,
                position.longitude,
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _buildButton(
          label: '사진 업로드',
          icon: Icons.upload_file,
          onTap: () async {
            final picker = ImagePicker();
            final XFile? file =
                await picker.pickImage(source: ImageSource.gallery);
            if (file != null) {
              viewModel.setSelectedImage(File(file.path));
              final position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              await viewModel.addMarkerAtCurrentLocationWithCoordinates(
                position.latitude,
                position.longitude,
              );
              await viewModel.uploadImage(
                position.latitude,
                position.longitude,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPloggingButton() {
    return Obx(() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              if (viewModel.isTracking.value) {
                // 플로깅 종료
                await viewModel.handleFinishPlogging();
              } else {
                // 플로깅 시작
                await viewModel.startPlogging();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      viewModel.isTracking.value ? "플로깅 FINISH" : "플로깅 START",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorSystem.main,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    viewModel.isTracking.value ? Icons.pause : Icons.play_arrow,
                    size: 24,
                    color: ColorSystem.main,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorSystem.main,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 24, color: ColorSystem.main),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
