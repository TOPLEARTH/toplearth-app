import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/finish_plogging_condition.dart';
import 'package:toplearth/domain/condition/plogging/plogging_labeling_condition.dart';
import 'package:toplearth/domain/condition/plogging/start_individual_plogging_condition.dart';
import 'package:toplearth/domain/entity/plogging/plogging_finish_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_list_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_start_individual_state.dart';
import 'package:toplearth/domain/type/e_labeling_status.dart';
import 'package:toplearth/domain/usecase/plogging/finish_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/labeling_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/start_individual_plogging_usecase.dart';
import 'package:toplearth/presentation/view/plogging/plogging_path_painter.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/upload_plogging_image_condition.dart';
import 'package:toplearth/domain/usecase/plogging/upload_plogging_image_usecase.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'dart:typed_data';

class PloggingViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* DI Fields -------------------------------------------- */
  /* ------------------------------------------------------ */
  late final UploadPloggingImageUseCase _uploadPloggingImageUseCase;
  late final StartIndividualPloggingUseCase _startIndividualPloggingUseCase;
  late final FinishPloggingUseCase _finishPloggingUsecase;
  late final LabelingPloggingUseCase _labelingPloggingUseCase;
  late final RootViewModel _rootViewModel;
  final Rx<PloggingImageListState> _ploggingImageListState =
      PloggingImageListState(ploggingImages: []).obs;
  // ScreenshotController 추가
  final ScreenshotController screenshotController = ScreenshotController();
  /* ------------------------------------------------------ */
  /* Private Fields --------------------------------------- */
  /* ------------------------------------------------------ */
  late NaverMapController _mapController;
  Timer? _timer;
  NLatLng? _currentLocation;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  //regionId
  late int regionId;
  // ploggingId
  late int ploggingId;

  // dummy data
  final double distance = 5.5; // km
  final int duration = 3600; // 초
  final int pickUpCnt = 15; // 수거 갯수
  final int burnedCalories = 200; // 칼로리
  final Rx<File?> ploggingImage = File('assets/images/test_image.jpg').obs;

  /* ------------------------------------------------------ */
  /* Observable Fields ------------------------------------ */
  /* ------------------------------------------------------ */
  final isTracking = false.obs;
  final ploggingTime = Duration.zero.obs;
  final routeCoordinates = <NLatLng>[].obs;
  final currentZoom = 16.0.obs;
  final trashBinMarkers = <NMarker>[].obs;
  RxList<NMarker> userMarkers = <NMarker>[].obs;
  final showTrashBins = false.obs;
  RxBool isFollowingLocation = false.obs; // 위치 추적 상태를 관리할 변수 추가

  late StreamSubscription<Position> _positionStreamSubscription;
  /* ------------------------------------------------------ */
  /* Public Methods -------------------------------------- */
  /* ------------------------------------------------------ */

  @override
  void onInit() {
    super.onInit();
    // RootViewModel 인스턴스 가져오기
    _rootViewModel = Get.find<RootViewModel>();
    _checkLocationPermission();
    _uploadPloggingImageUseCase = Get.find<UploadPloggingImageUseCase>();
    _startIndividualPloggingUseCase =
        Get.find<StartIndividualPloggingUseCase>();
    _finishPloggingUsecase = Get.find<FinishPloggingUseCase>();
    _labelingPloggingUseCase = Get.find<LabelingPloggingUseCase>();

    ever(_rootViewModel.regionId, (int newRegionId) {
      regionId = newRegionId;
      debugPrint("Updated regionId in PloggingViewModel: $regionId");
    });
  }

  @override
  void onClose() {
    _positionStreamSubscription.cancel();
    super.onClose();
  }

  void setSelectedImage(File? image) {
    selectedImage.value = image;
  }

  Future<ResultWrapper> startIndividualPlogging() async {
    StateWrapper<PloggingStartIndividualState> state =
        await _startIndividualPloggingUseCase
            .execute(StartIndividualPloggingCondition(regionId: regionId));
    ploggingId = state.data!.ploggingId;

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  // Future<ResultWrapper> startTeamPlogging(int regionId) async {
  //   StateWrapper<void> state = await _startIndividualPloggingUseCase
  //       .execute(StartIndividualPloggingCondition(regionId: regionId));
  //
  //   return ResultWrapper(
  //     success: state.success,
  //     message: state.message,
  //   );
  // }

  Future<ResultWrapper> finishPlogging() async {
    // 플로깅 종료 API 호출
    StateWrapper<PloggingImageListState> state =
        await _finishPloggingUsecase.execute(FinishPloggingCondition(
      ploggingId: ploggingId,
      ploggingData: PloggingFinishState(
        distance: distance,
        duration: duration,
        pickUpCnt: pickUpCnt,
        burnedCalories: burnedCalories,
      ),
    ));
    // 상태 업데이트
    if (state.success && state.data != null) {
      _ploggingImageListState.value = state.data!; // 상태 업데이트
      debugPrint(
          'FinishPlogging Response Data: ${state.data!.ploggingImages.first}');
      for (var image in _ploggingImageListState.value.ploggingImages) {
        debugPrint(
            'Image ID: ${image.ploggingImageId}, URL: ${image.imageUrl}');
      }
    } else {
      debugPrint('FinishPlogging Failed: ${state.message}');
    }

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }


  Future<ResultWrapper> labelingPloggingImages() async {
    if (ploggingImage.value == null) {
      return ResultWrapper(
        success: false,
        message: '캡처된 이미지가 없습니다.',
      );
    }

    // 이미지 ID 리스트와 라벨 리스트 매핑
    final List<int> imageIds = _ploggingImageListState.value.ploggingImages
        .map((e) => e.ploggingImageId!)
        .toList();

    // 예시: 모든 이미지에 동일한 라벨링 처리 (실제는 동적 구성 가능)
    final List<String> labels = List.generate(
        imageIds.length, (_) => ELabelingStatus.plastic.toString());

    // 리스트 크기 확인
    if (imageIds.length != labels.length) {
      return ResultWrapper(
        success: false,
        message: '이미지 ID와 라벨 리스트의 크기가 일치하지 않습니다.',
      );
    }
    try {
      StateWrapper<void> state = await _labelingPloggingUseCase.execute(
        PloggingLabelingCondition(
          ploggingId: ploggingId,
          ploggingImage: ploggingImage.value!, // 캡처된 이미지
          ploggingImageIds: imageIds,
          labels: labels,
        ),
      );

      if (!state.success) {
        return ResultWrapper(
          success: false,
          message: state.message,
        );
      }

      return ResultWrapper(
        success: true,
        message: '라벨링이 성공적으로 처리되었습니다.',
      );
    } catch (e) {
      return ResultWrapper(
        success: false,
        message: '라벨링 처리 중 오류 발생: $e',
      );
    }
  }

  Future<ResultWrapper> uploadImage(double latitude, double longitude) async {
    if (selectedImage.value == null) {
      return ResultWrapper(success: false, message: '이미지를 선택해주세요.');
    }
    isLoading.value = true;
    StateWrapper<void> state = await _uploadPloggingImageUseCase.execute(
      UploadPloggingImageCondition(
        ploddingImage: selectedImage.value!,
        ploggingId: ploggingId,
        latitude: latitude,
        longitude: longitude,
      ),
    );
    isLoading.value = false;

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  void onMapReady(NaverMapController controller) {
    _mapController = controller;
    _addTrashBinMarkers();
  }

  Future<void> startPlogging() async {
    isTracking.value = true;

    // 플로깅 시작 요청 및 ploggingId 업데이트
    try {
      StateWrapper<PloggingStartIndividualState> state =
          await _startIndividualPloggingUseCase.execute(
        StartIndividualPloggingCondition(regionId: regionId),
      );

      if (state.success && state.data != null) {
        ploggingId = state.data!.ploggingId; // ploggingId 업데이트
        debugPrint("Plogging started with ID: $ploggingId");
      } else {
        debugPrint("Failed to start plogging: ${state.message}");
        return; // 요청 실패 시 중단
      }
    } catch (e) {
      debugPrint("Error while starting plogging: $e");
      return; // 에러 발생 시 중단
    }

    // 위치 스트림 시작
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // 5미터마다 업데이트
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      _currentLocation = NLatLng(position.latitude, position.longitude);
      routeCoordinates.add(_currentLocation!);

      if (isFollowingLocation.value) {
        _updateCamera();
      }

      _drawPath();
    });

    _startTimer();
  }

  Future<void> stopPlogging() async {
    isTracking.value = false;
    _stopTimer();

    _startIndividualPloggingUseCase
        .execute(StartIndividualPloggingCondition(regionId: regionId));

    if (routeCoordinates.isNotEmpty) {
      await showRouteCanvas(); // 플로깅 종료 시 자동 저장
      Get.defaultDialog(
        title: "Plogging Complete",
        content: Text("Total Time: ${_formatDuration(ploggingTime.value)}"),
        onConfirm: () => Get.back(),
      );
    }
  }

  Future<void> zoomIn() async {
    currentZoom.value = (currentZoom.value + 1).clamp(0.0, 21.0);
    await _updateCamera();
  }

  Future<void> zoomOut() async {
    currentZoom.value = (currentZoom.value - 1).clamp(0.0, 21.0);
    await _updateCamera();
  }

  Future<void> toggleTrashBins() async {
    showTrashBins.toggle();
    if (showTrashBins.value) {
      await _addTrashBinMarkers();
    } else {
      for (var marker in trashBinMarkers) {
        await _mapController.deleteOverlay(marker.info);
      }
      trashBinMarkers.clear();
    }
  }

  /* ------------------------------------------------------ */
  /* Private Methods ------------------------------------- */
  /* ------------------------------------------------------ */
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      ploggingTime.value += const Duration(seconds: 2);
      _updateCurrentLocation();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _updateCamera() async {
    await _mapController.updateCamera(
      NCameraUpdate.fromCameraPosition(
        NCameraPosition(
          target: _currentLocation ?? NLatLng(37.5665, 126.9780),
          zoom: currentZoom.value,
        ),
      ),
    );
  }

  // _updateCurrentLocation 메서드 수정
  Future<void> _updateCurrentLocation() async {
    final newLocation = _currentLocation ?? const NLatLng(37.5665, 126.9780);
    final nextLocation = _getNewLocationByDistance(newLocation, 300);

    _currentLocation = nextLocation;
    routeCoordinates.add(nextLocation);
    await _drawPath();

    // 위치 추적 모드일 때만 카메라 업데이트
    if (isFollowingLocation.value) {
      await _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(NCameraPosition(
          target: nextLocation,
          zoom: currentZoom.value,
        )),
      );
    }
  }

  Future<void> moveToCurrentLocation() async {
    isFollowingLocation.toggle(); // 추적 상태 토글

    if (isFollowingLocation.value) {
      // 위치 추적 시작
      _startLocationTracking();
    } else {
      // 위치 추적 중지
      _stopLocationTracking();
    }
  }

  void _startLocationTracking() {
    // 현재 위치로 카메라 이동
    if (_currentLocation != null) {
      _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: _currentLocation!,
            zoom: currentZoom.value,
          ),
        ),
      );
    }
  }

  void _stopLocationTracking() {
    // 추적 중지 시 필요한 로직
  }
  double angle = 0;

  /// Calculate a new location by moving a certain distance in meters
  NLatLng _getNewLocationByDistance(
      NLatLng currentLocation, double distanceInMeters) {
    const double earthRadius = 6371000; // 지구 반경(미터)
    // 각도 증가 (0 ~ 360도)
    angle = (angle + 20) % 360; // 45도씩 회전
    final radian = angle * (math.pi / 180);

    final double latOffset =
        (distanceInMeters * math.cos(radian) / earthRadius) * (180 / math.pi);
    final double lngOffset =
        (distanceInMeters * math.sin(radian) / earthRadius) *
            (180 / math.pi) /
            math.cos(currentLocation.latitude * math.pi / 180);

    return NLatLng(
      currentLocation.latitude + latOffset,
      currentLocation.longitude + lngOffset,
    );
  }

  Future<void> addMarkerAtCurrentLocation() async {
    if (_currentLocation == null) return;

    try {
      // 마커 이미지 설정
      final iconImage = await const NOverlayImage.fromAssetImage(
          'assets/icons/test_marker.png');

      // 현재 위치에 마커 생성
      final marker = NMarker(
        id: 'user_marker_${userMarkers.length}',
        position: _currentLocation!,
        icon: iconImage,
      );

      // 마커 추가
      await _mapController.addOverlay(marker);
      userMarkers.add(marker);

      Get.snackbar(
        '마커 추가',
        '현재 위치에 마커가 추가되었습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '오류',
        '마커 추가 실패',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //길 그릭
  Future<void> _drawPath() async {
    if (routeCoordinates.isNotEmpty) {
      final pathOverlay = NPathOverlay(
        id: 'plogging',
        coords: routeCoordinates,
        width: 12,
        color: Colors.green,
      );
      await _mapController.addOverlay(pathOverlay);
    }
  }

  Future<void> _addTrashBinMarkers() async {
    final iconImage = await const NOverlayImage.fromAssetImage(
        'assets/icons/test_marker.png');
    final List<NLatLng> nearbyTrashBins = _generateNearbyTrashBins();

    // Generate markers with tap listeners
    trashBinMarkers.value = nearbyTrashBins
        .asMap()
        .entries
        .map((entry) => NMarker(
              id: 'trash_bin_${entry.key}',
              position: entry.value,
              icon: iconImage,
              // onTap: (marker) {
              //   // Show a modal or perform an action
              //   Get.defaultDialog(
              //     title: "Trash Bin Details",
              //     content: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Text("Marker ID: ${marker.info.id}"),
              //         Text(
              //             "Position: ${marker.position.latitude}, ${marker.position.longitude}"),
              //         const SizedBox(height: 10),
              //         ElevatedButton(
              //           onPressed: () => Get.back(), // Close dialog
              //           child: const Text("Close"),
              //         ),
              //       ],
              //     ),
              //   );
              // },
            ))
        .toList();

    // Add markers to the map
    await _mapController.addOverlayAll(trashBinMarkers.toSet());
  }

  List<NLatLng> _generateNearbyTrashBins() {
    final baseLocation = _currentLocation ?? NLatLng(37.5665, 126.9780);
    return [
      _getNewLocationByDistance(baseLocation, 10), // 10m away
      _getNewLocationByDistance(baseLocation, 20),
      _getNewLocationByDistance(baseLocation, 30),
      _getNewLocationByDistance(baseLocation, 40),
      _getNewLocationByDistance(baseLocation, 50),
    ];
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String convertRouteToSVGPath(List<NLatLng> coordinates) {
    if (coordinates.isEmpty) return '';

    // SVG 경로 시작점
    final start = coordinates.first;
    StringBuffer path = StringBuffer();

    // Move to 시작점
    path.write('M ${start.longitude} ${start.latitude} ');

    // 나머지 포인트들은 Line to로 연결
    for (int i = 1; i < coordinates.length; i++) {
      final point = coordinates[i];
      path.write('L ${point.longitude} ${point.latitude} ');
    }

    // 경로 닫기
    path.write('Z');

    return path.toString();
  }

  Future<ui.Image> _loadMarkerImage() async {
    final pictureInfo = await vg.loadPicture(
      const SvgAssetLoader('assets/icons/location.svg'),
      null,
    );

    return pictureInfo.picture.toImage(48, 48);
  }

  Future<void> showRouteCanvas() async {
    if (routeCoordinates.isEmpty) return;

    final markerImage = await _loadMarkerImage();

    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('플로깅 경로', style: FontSystem.H3),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: PloggingPathPainter(
                    routeCoordinates,
                    markerPoints: userMarkers.map((m) => m.position).toList(),
                    markerImage: markerImage,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showRouteSVG() async {
    if (routeCoordinates.isEmpty) return;

    // 좌표 정규화
    final normalizedCoords = _normalizeCoordinates();
    final pathData = _createSVGPathData(normalizedCoords);

    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('플로깅 경로', style: FontSystem.H3),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.string(
                    '''
                  <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="$pathData"
                      fill="none"
                      stroke="green"
                      stroke-width="2"
                    />
                  </svg>
                  ''',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<math.Point> _normalizeCoordinates() {
    if (routeCoordinates.isEmpty) return [];

    // 좌표 범위 계산
    double minLat = routeCoordinates.first.latitude;
    double maxLat = minLat;
    double minLng = routeCoordinates.first.longitude;
    double maxLng = minLng;

    for (var coord in routeCoordinates) {
      minLat = math.min(minLat, coord.latitude);
      maxLat = math.max(maxLat, coord.latitude);
      minLng = math.min(minLng, coord.longitude);
      maxLng = math.max(maxLng, coord.longitude);
    }

    // 0~100 범위로 정규화
    return routeCoordinates.map((coord) {
      final x = ((coord.longitude - minLng) / (maxLng - minLng)) * 100;
      final y = ((coord.latitude - minLat) / (maxLat - minLat)) * 100;
      return math.Point(x, y);
    }).toList();
  }

  String _createSVGPathData(List<math.Point> normalizedPoints) {
    if (normalizedPoints.isEmpty) return '';

    final start = normalizedPoints.first;
    StringBuffer path = StringBuffer();

    path.write('M ${start.x} ${start.y} ');

    for (int i = 1; i < normalizedPoints.length; i++) {
      final point = normalizedPoints[i];
      path.write('L ${point.x} ${point.y} ');
    }

    return path.toString();
  }
}
