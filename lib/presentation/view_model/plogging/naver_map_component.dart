import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:toplearth/presentation/view/matching/MapControllerManager.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class NaverMapComponent extends StatelessWidget {
  final double width;
  final double height;
  final double initialZoom;

  const NaverMapComponent({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.initialZoom = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<PloggingViewModel>();

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Obx(() {
            final currentLocation = viewModel.currentLocation.value;

            return NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: currentLocation,
                  zoom: initialZoom,
                ),
              ),
              onMapReady: (controller) {
                if (!MapControllerManager().isControllerInitialized) {
                  MapControllerManager().setController(controller);
                }
                viewModel.onMapReady(controller);
              },
            );
          }),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  await viewModel.initializeCurrentLocation();
                  Get.snackbar('위치 초기화', '현재 위치를 새로고침했습니다.');
                } catch (e) {
                  Get.snackbar('오류', '위치를 가져오는 데 실패했습니다.');
                }
              },
              mini: true,
              backgroundColor: Colors.white,
              child: const Icon(Icons.refresh, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
