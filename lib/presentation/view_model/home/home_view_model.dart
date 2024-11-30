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
  bool get isLoading => _isLoading.value;

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
    ever(
      _rootViewModel.isBootstrapLoaded,
      (isLoaded) {
        if (isLoaded) {
          // Bootstrap 데이터가 로드된 이후 업데이트
          _userState.value = _rootViewModel.userState;
          _questInfoState.value = _rootViewModel.questInfoState;
          _regionRankingInfoState.value = _rootViewModel.regionRankingInfoState;
          _homeInfoState.value = _rootViewModel.homeInfoState;
        }
      },
    );
  }

  // 위치 조회 및 RootViewModel 업데이트
  Future<void> fetchCurrentLocation() async {
    try {
      await _rootViewModel.fetchCurrentLocation();
      latitude.value = _rootViewModel.latitude.value;
      longitude.value = _rootViewModel.longitude.value;
      regionName.value = _rootViewModel.regionName.value;
      regionId.value = _rootViewModel.regionId.value;
    } catch (e) {
      Get.snackbar('오류', '위치를 가져오는 데 실패했습니다.');
    }
  }

  // Earth/Map 토글
  void toggleView() {
    showEarthView.value = !showEarthView.value;
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
