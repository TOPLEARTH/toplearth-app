import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/domain/condition/home/set_goal_distance_condition.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/home/home_info_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/usecase/home/set_goal_distance_usecase.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final RootViewModel _rootViewModel;
  late final SetGoalDistanceUseCase _setGoalDistanceUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final Rx<UserState> _userState;
  late final Rx<QuestInfoState> _questInfoState;
  late final Rx<RegionRankingInfoState> _regionRankingInfoState;
  late final Rx<HomeInfoState> _homeInfoState;

  RxBool isLoading = false.obs; // 로딩 상태 변수

  late final RxBool _isLoading;

  /* 전역 상태로 관리할 위치 정보 */
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString regionName = '현재 위치를 조회해요!'.obs; // 초기 상태
  RxInt regionId = 0.obs;
  RxBool showEarthView = true.obs;
  RxBool showModal = false.obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  UserState get userState => _userState.value;
  QuestInfoState get questInfoState => _questInfoState.value;
  RegionRankingInfoState get regionRankingInfoState =>
      _regionRankingInfoState.value;
  HomeInfoState get homeInfoState => _homeInfoState.value;
  @override
  void onInit() {
    super.onInit();
    _rootViewModel = Get.find<RootViewModel>();
    _setGoalDistanceUseCase = Get.find<SetGoalDistanceUseCase>();
    // 초기값 세팅 (빈 값 대체)
    _userState = UserState.initial().obs;
    _questInfoState = QuestInfoState.initial().obs;
    _regionRankingInfoState = RegionRankingInfoState.initial().obs;
    _homeInfoState = HomeInfoState.initial().obs;
    // RootViewModel의 isBootstrapLoaded 상태 변화를 감지
    _isLoading = false.obs;
    // RootViewModel의 상태를 동기화

    ever(_rootViewModel.isBootstrapLoaded, (isLoaded) {
      if (isLoaded) {
        // Bootstrap 데이터가 로드된 이후 업데이트
        _userState.value = _rootViewModel.userState;
        _questInfoState.value = _rootViewModel.questInfoState;
        _regionRankingInfoState.value = _rootViewModel.regionRankingInfoState;
        _homeInfoState.value = _rootViewModel.homeInfoState;
      }
    });
    // 권한 확인 및 위치 조회
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      isLoading.value = true; // 로딩 시작
      await fetchCurrentLocation(); // 권한 동의 및 현재 위치 조회
    } catch (e) {
      Get.snackbar('오류', '위치를 가져오는 데 실패했습니다.');
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }

  // 위치 조회 및 RootViewModel 업데이트
  Future<void> fetchCurrentLocation() async {
    try {
      // 위치 권한 확인 및 요청
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('위치 서비스가 비활성화되었습니다.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('위치 권한이 거부되었습니다.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한이 영구적으로 거부되었습니다.');
      }

      // 현재 위치 조회
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // 지역 정보 업데이트
      await _fetchRegionInfo(position.latitude, position.longitude);
    } catch (e) {}
  }

  // 위도/경도를 기반으로 지역 및 regionId 조회
  Future<void> _fetchRegionInfo(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        String? area = placemarks.first.subAdministrativeArea;

        if (area == null || !area.contains('구')) {
          area = await fetchRegionFromNaverAPI(lat, lng);
        }

        if (area != null && area.contains('구')) {
          regionName.value = '서울시 $area';
          regionId.value = _getRegionId(area); // regionId 업데이트
        } else {
          regionName.value = '지역 정보를 찾을 수 없습니다.';
          regionId.value = 0;
        }
      } else {
        debugPrint('No placemarks found for the coordinates.');
      }
    } catch (e) {
      debugPrint('Error fetching region info: $e');
    }
  }

  // Earth/Map 토글
  void toggleView() {
    showEarthView.value = !showEarthView.value;
  }

  int _getRegionId(String? areaName) {
    const Map<String, int> regionMapping = {
      '용산구': 1,
      '서초구': 2,
      '강남구': 3,
      '송파구': 4,
      '강동구': 5,
      '광진구': 6,
      '중랑구': 7,
      '노원구': 8,
      '도봉구': 9,
      '강북구': 10,
      '성북구': 11,
      '동대문구': 12,
      '성동구': 13,
      '중구': 14,
      '종로구': 15,
      '서대문구': 16,
      '은평구': 17,
      '마포구': 18,
      '강서구': 19,
      '양천구': 20,
      '영등포구': 21,
      '구로구': 22,
      '금천구': 23,
      '관악구': 24,
      '동작구': 25,
    };
    return regionMapping[areaName] ?? 0; // 지역이 없으면 기본값 0 반환
  }

  // Modal 상태 전환
  void toggleModal() {
    showModal.value = !showModal.value;
  }

  Future<ResultWrapper> setGoalDistance(double distance) async {
    _isLoading.value = true;
    try {
      final state = await _setGoalDistanceUseCase.execute(
        SetGoalDistanceCondition(distance),
      );
      // 목표 설정 후 Bootstrap 정보 다시 가져오기 -> 바로 UI에 반영 안됨
      if (state.success) {
        await _rootViewModel.fetchBootstrapInformation();
        return ResultWrapper(success: true, message: '목표 거리가 설정되었습니다.');
      } else {
        return ResultWrapper(success: false, message: state.message);
      }
    } catch (e) {
      return ResultWrapper(success: false, message: '오류가 발생했습니다: $e');
    } finally {
      _isLoading.value = false;
    }
  }
}
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
// import 'package:toplearth/domain/entity/global/region_ranking_state.dart';
// import 'package:toplearth/domain/entity/user/user_state.dart';
// import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
// import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
//
// class HomeViewModel extends GetxController {
//   /* ------------------------------------------------------ */
//   /* -------------------- DI Fields ----------------------- */
//   /* ------------------------------------------------------ */
//   late final RootViewModel _rootViewModel;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Private Fields --------------------- */
//   /* ------------------------------------------------------ */
//   late final Rx<UserState> _userState;
//   late final Rx<QuestInfoState> _questInfoState;
//   late final Rx<RegionRankingInfoState> _regionRankingInfoState;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Public Fields ---------------------- */
//   /* ------------------------------------------------------ */
//   UserState get userState => _userState.value;
//   QuestInfoState get questInfoState => _questInfoState.value;
//   RegionRankingInfoState get regionRankingInfoState => _regionRankingInfoState.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // RootViewModel 의존성 주입
//     _rootViewModel = Get.find<RootViewModel>();
//
//     // bootstrap에서 받은 데이터를 각각의 State에 할당
//     _userState = _rootViewModel.userState.obs;
//     _questInfoState = _rootViewModel.questInfoState.obs;
//     _regionRankingInfoState = _rootViewModel.regionRankingInfoState.obs;
//
//     debugPrint('debug in userViewModel ${userState.nickname}');
//
//   }
// }
