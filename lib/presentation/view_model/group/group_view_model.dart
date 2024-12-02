import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/domain/entity/group/monthly_group_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class GroupViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final RootViewModel _rootViewModel;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final Rx<TeamInfoState> _teamInfoState;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  TeamInfoState get teamInfoState => _teamInfoState.value;

  MonthlyGroupState? get currentMonthData {
    final currentMonth =
        DateTime.now().toIso8601String().substring(0, 7); // e.g., "2024-12"
    return teamInfoState.monthlyData![currentMonth];
  }

  @override
  void onInit() {
    super.onInit();

    // RootViewModel DI 설정
    _rootViewModel = Get.find<RootViewModel>();

    // 초기값 세팅 (빈 값 대체)
    _teamInfoState = TeamInfoState.initial().obs;

    // RootViewModel의 isBootstrapLoaded 상태 변화를 감지
    ever(_rootViewModel.isBootstrapLoaded, (isLoaded) {
      if (isLoaded) {
        // Bootstrap 데이터가 로드된 이후 업데이트
        _teamInfoState.value = _rootViewModel.teamInfoState.value;
        debugPrint('debug in groupViewModel: ${teamInfoState.teamName}');
        debugPrint('debug in groupViewModel: ${teamInfoState.teamCode}');
      }
    });
  }
}
// import 'package:get/get.dart';
// import 'package:toplearth/domain/entity/group/team_info_state.dart';
// import 'package:toplearth/domain/entity/group/monthly_group_state.dart';
// import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
//
// class GroupViewModel extends GetxController {
//   /* ------------------------------------------------------ */
//   /* -------------------- DI Fields ----------------------- */
//   /* ------------------------------------------------------ */
//   late final RootViewModel _rootViewModel;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Private Fields --------------------- */
//   /* ------------------------------------------------------ */
//   final Rx<TeamInfoState> _teamInfoState = TeamInfoState.initial().obs;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Public Fields ---------------------- */
//   /* ------------------------------------------------------ */
//   TeamInfoState get teamInfoState => _teamInfoState.value;
//
//   MonthlyGroupState? get currentMonthData {
//     final currentMonth = DateTime.now().toIso8601String().substring(0, 7); // e.g., "2024-12"
//     return teamInfoState.monthlyData[currentMonth];
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // RootViewModel DI 설정
//     _rootViewModel = Get.find<RootViewModel>();
//     // Private Fields 초기화
//     _teamInfoState.value = _rootViewModel.teamInfoState;
//   }
// }
