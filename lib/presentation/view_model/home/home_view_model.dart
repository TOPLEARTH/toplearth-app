import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final RootViewModel _rootViewModel;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final Rx<UserState> _userState;
  late final Rx<QuestInfoState> _questInfoState;
  late final Rx<RegionRankingInfoState> _regionRankingInfoState;

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

  @override
  void onInit() {
    super.onInit();

    _rootViewModel = Get.find<RootViewModel>();

    // 초기값 세팅
    _userState = UserState.initial().obs;
    _questInfoState = QuestInfoState.initial.obs;
    _regionRankingInfoState = RegionRankingInfoState.initial().obs;

    // RootViewModel의 상태를 동기화
    ever(_rootViewModel.isBootstrapLoaded, (isLoaded) {
      if (isLoaded) {
        _userState.value = _rootViewModel.userState;
        _questInfoState.value = _rootViewModel.questInfoState;
        _regionRankingInfoState.value = _rootViewModel.regionRankingInfoState;
      }
    });
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
}
