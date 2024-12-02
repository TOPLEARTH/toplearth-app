import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/finish_plogging_condition.dart';
import 'package:toplearth/domain/condition/plogging/plogging_labeling_condition.dart';
import 'package:toplearth/domain/condition/plogging/start_individual_plogging_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_finish_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_list_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_start_individual_state.dart';
import 'package:toplearth/domain/type/e_labeling_status.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/domain/usecase/plogging/finish_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/labeling_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/start_individual_plogging_usecase.dart';
import 'package:toplearth/presentation/view/plogging/plogging_path_painter.dart';
import 'dart:io';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/upload_plogging_image_condition.dart';
import 'package:toplearth/domain/usecase/plogging/upload_plogging_image_usecase.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/plogging/MapHelper.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class PloggingViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* DI Fields -------------------------------------------- */
  /* ------------------------------------------------------ */

  late final UploadPloggingImageUseCase _uploadPloggingImageUseCase;
  late final StartIndividualPloggingUseCase _startIndividualPloggingUseCase;
  late final FinishPloggingUseCase _finishPloggingUsecase;
  late final LabelingPloggingUseCase _labelingPloggingUseCase;
  late final RootViewModel _rootViewModel;
  Rx<NLatLng> currentLocation = NLatLng(0.0, 0.0).obs;
  final Rx<PloggingImageListState> _ploggingImageListState =
      PloggingImageListState(ploggingImages: []).obs;
  // ScreenshotController 추가
  final ScreenshotController screenshotController = ScreenshotController();
  /* ------------------------------------------------------ */
  /* Private Fields --------------------------------------- */
  /* ------------------------------------------------------ */
  final RxBool showPhotoMarkers = false.obs; // 사진 기반 마커 가시성 상태
  final RxList<NMarker> photoMarkers = <NMarker>[].obs; // 사진 마커 리스트

  late NaverMapController _mapController;
  RxBool isLocationEnabled = false.obs;
  Timer? _timer;
  NLatLng? _currentLocation;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  //regionId
  int regionId = 14;
  // ploggingId
  late int ploggingId;

  // dummy data
  final double distance = 5.5; // km
  final int duration = 3600; // 초
  final int pickUpCnt = 15; // 수거 갯수
  final int burnedCalories = 200; // 칼로리
  final Rx<File?> ploggingImage = File('assets/icons/clean_marker.png').obs;

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

    // RootViewModel의 위치 변경을 감지하여 currentLocation 업데이트
    ever(_rootViewModel.latitude, (_) => _updateCurrentLocation());
    ever(_rootViewModel.longitude, (_) => _updateCurrentLocation());
  }

  @override
  void onClose() {
    _positionStreamSubscription.cancel();
    super.onClose();
  }

  void setSelectedImage(File? image) {
    selectedImage.value = image;
  }

  /// 위치 초기화 메서드
  Future<void> initializeCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation.value = NLatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('위치 정보를 불러오는 데 실패했습니다: $e');
      // 기본 위치: 서울
      currentLocation.value = NLatLng(37.5665, 126.9780);
    }
  }

  Future<ResultWrapper> startIndividualPlogging() async {
    StateWrapper<PloggingStartIndividualState> state =
        await _startIndividualPloggingUseCase
            .execute(StartIndividualPloggingCondition(regionId: 14));
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

  Future<void> handleFinishPlogging() async {
    final result = await finishPlogging();

    if (result.success) {
      debugPrint(
          "FinishPlogging 성공: ${_ploggingImageListState.value.ploggingImages}");

      // 라벨링을 위한 이미지 데이터 준비
      final ploggingImages = _ploggingImageListState.value.ploggingImages
          .map((image) => {
                'ploggingImageId': image.ploggingImageId,
                'imageUrl': image.imageUrl,
                'createdAt': image.createdAt,
              })
          .toList();

      // 라벨링 화면으로 데이터 전달
      Get.toNamed(
        AppRoutes.PLOGGING_LABELING,
        arguments: {'ploggingImages': ploggingImages},
      );
    } else {
      debugPrint("FinishPlogging 실패: ${result.message}");
      Get.snackbar('오류', result.message ?? '플로깅 종료 중 문제가 발생했습니다.');
    }
  }

  Future<ResultWrapper> finishPlogging() async {
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

    if (state.success && state.data != null) {
      _ploggingImageListState.value = state.data!;
      debugPrint('FinishPlogging Data: ${state.data!.ploggingImages}');
    } else {
      debugPrint('FinishPlogging Failed: ${state.message}');
    }

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  Future<ResultWrapper> labelingPloggingImages(
      List<int> imageIds, List<String> labels, File screenshotFile) async {
    if (imageIds.length != labels.length) {
      return ResultWrapper(
          success: false, message: '이미지 ID와 라벨 리스트 크기가 일치하지 않습니다.');
    }

    try {
      StateWrapper<void> state = await _labelingPloggingUseCase.execute(
        PloggingLabelingCondition(
          ploggingId: ploggingId,
          ploggingImage: screenshotFile, // Use the screenshot file here
          ploggingImageIds: imageIds,
          labels: labels,
        ),
      );

      if (!state.success) {
        return ResultWrapper(success: false, message: state.message);
      }

      return ResultWrapper(success: true, message: '라벨링 완료');
    } catch (e) {
      return ResultWrapper(success: false, message: '라벨링 처리 중 오류: $e');
    }
  }

  Future<void> addMarkerAtCurrentLocationWithCoordinates(
      double latitude, double longitude) async {
    try {
      await mapHelper.addCleanMarker(
        latitude,
        longitude,
      );

      Get.snackbar('성공', '마커 추가 완료');
    } catch (e) {
      rethrow; // 에러를 상위로 전달
    }
  }

  Future<ResultWrapper> uploadImage(double latitude, double longitude) async {
    if (selectedImage.value == null) {
      return ResultWrapper(success: false, message: '이미지를 선택해주세요.');
    }
    isLoading.value = true;

    // 업로드 API 호출
    StateWrapper<void> state = await _uploadPloggingImageUseCase.execute(
      UploadPloggingImageCondition(
        ploddingImage: selectedImage.value!,
        ploggingId: ploggingId,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    isLoading.value = false;

    if (state.success) {
      try {
        await addMarkerAtCurrentLocationWithCoordinates(latitude, longitude);
        Get.snackbar('성공', '사진 업로드 및 마커 추가 성공!');
        return ResultWrapper(success: true);
      } catch (e) {
        rethrow;
      }
    } else {
      return ResultWrapper(success: false, message: state.message);
    }
  }

  Future<void> togglePhotoMarkers() async {
    // 사진 마커 가시성 상태 토글
    showPhotoMarkers.toggle();

    try {
      if (showPhotoMarkers.value) {
        // 사진 마커 표시
        for (var marker in photoMarkers) {
          await _mapController.addOverlay(marker); // 개별 마커 추가
        }
        Get.snackbar('마커 표시', '사진 기반 마커가 표시되었습니다.');
      } else {
        // 사진 마커 숨김
        for (var marker in photoMarkers) {
          await _mapController.deleteOverlay(marker.info); // 개별 마커 제거
        }
        Get.snackbar('마커 숨김', '사진 기반 마커가 숨겨졌습니다.');
      }
    } catch (e) {
      Get.snackbar('오류', '사진 마커 처리 중 오류가 발생했습니다.');
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("위치 서비스 비활성화", "위치 서비스를 활성화해주세요.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("위치 권한 필요", "위치 권한을 허용해주세요.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("위치 권한 필요", "앱 설정에서 위치 권한을 허용해주세요.");
      return;
    }

    isLocationEnabled.value = true;
  }

  final MapHelper mapHelper = MapHelper();

  void onMapReady(NaverMapController controller) {
    _mapController = controller;
    mapHelper.initialize(controller);
    _mapController.getLocationTrackingMode();
    mapHelper.addCurrentLocationMarker();
    mapHelper.addTrashBinMarkers(); // Add trash bin markers
    _updateCurrentLocation();
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

      // MatchingGroupViewModel 및 RootViewModel의 상태 업데이트
      final matchingGroupViewModel = Get.find<MatchingGroupViewModel>();
      final rootViewModel = Get.find<RootViewModel>();

      matchingGroupViewModel.setMatchingStatus(EMatchingStatus.PLOGGING);
      rootViewModel.matchingStatusState.value = MatchingStatusState(
        status: EMatchingStatus.PLOGGING,
      );

      debugPrint("Matching status updated to PLOGGING");
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
  void _updateCurrentLocation() {
    final double lat = _rootViewModel.latitude.value;
    final double lng = _rootViewModel.longitude.value;

    debugPrint('위도: $lat, 경도: $lng');
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
    final iconImage =
        await const NOverlayImage.fromAssetImage('assets/icons/bin_marker.png');
    final List<NLatLng> nearbyTrashBins = _generateNearbyTrashBins();

    // Generate markers with tap listeners
    trashBinMarkers.value = nearbyTrashBins
        .asMap()
        .entries
        .map((entry) => NMarker(
              id: 'trash_bin_${entry.key}',
              position: entry.value,
              icon: iconImage,
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
