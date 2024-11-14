import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapController extends GetxController {
  late NaverMapController _naverMapController;
  RxBool isMapReady = false.obs;

  // 맵이 준비되었을 때 호출되는 함수
  void onMapReady(NaverMapController controller) {
    _naverMapController = controller;
    isMapReady.value = true;
    // 초기 위치나 마커 설정 등 추가 작업 가능
  }

  // 맵이 탭 되었을 때 호출되는 함수
  void onMapTapped(NPoint point, NLatLng latLng) {
    print("Map tapped at: ${latLng.latitude}, ${latLng.longitude}");
  }

  // 심볼이 탭 되었을 때 호출되는 함수
  void onSymbolTapped(NSymbolInfo symbolInfo) {
    print("Symbol tapped: ${symbolInfo}");
  }

  // 특정 위치로 카메라 이동 함수
  Future<void> moveCameraTo(NLatLng target, {double zoom = 15}) async {
    await _naverMapController.moveCameraTo(
      NCameraPosition(
        target: target,
        zoom: zoom,
      ) as NLatLng,
    );
  }
}

class NaverMapScreen extends StatelessWidget {
  final NaverMapController mapController = Get.put(NaverMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naver Map')),
      body: Obx(
            () => Stack(
          children: [
            NaverMap(
              onMapTapped: mapController.onMapTapped,
              onSymbolTapped: mapController.onSymbolTapped,
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: const NLatLng(37.5665, 126.9780), // 서울
                  zoom: 12,
                ),
              ),
            ),
            if (!mapController.isMapReady.value)
              const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.moveCameraTo(
            const NLatLng(37.5665, 126.9780), // 서울로 이동
          );
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
