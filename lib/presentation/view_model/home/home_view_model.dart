import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
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

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  UserState get userState => _userState.value;
  QuestInfoState get questInfoState => _questInfoState.value;
  RegionRankingInfoState get regionRankingInfoState => _regionRankingInfoState.value;

  @override
  void onInit() {
    super.onInit();

    _rootViewModel = Get.find<RootViewModel>();

    // 초기값 세팅 (빈 값 대체)
    _userState = UserState.initial().obs;
    _questInfoState = QuestInfoState.initial().obs;
    _regionRankingInfoState = RegionRankingInfoState.initial().obs;

    // RootViewModel의 isBootstrapLoaded 상태 변화를 감지
    ever(_rootViewModel.isBootstrapLoaded, (isLoaded) {
      if (isLoaded) {
        // Bootstrap 데이터가 로드된 이후 업데이트
        _userState.value = _rootViewModel.userState;
        _questInfoState.value = _rootViewModel.questInfoState;
        _regionRankingInfoState.value = _rootViewModel.regionRankingInfoState;
      debugPrint('debug in userViewModel: ${userState.nickname}');
      }
    });
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
