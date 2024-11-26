import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/domain/entity/global/legacy_info_state.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class LegacyViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final RootViewModel _rootViewModel;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final Rx<LegacyInfoState> _legacyInfoState;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  LegacyInfoState get legacyInfoState => _legacyInfoState.value;

  @override
  void onInit() {
    super.onInit();

    // RootViewModel 의존성 주입
    _rootViewModel = Get.find<RootViewModel>();

    // Private Fields 초기화
    _legacyInfoState = _rootViewModel.legacyInfoState.obs;

    debugPrint('debug in legacyViewModel: ${_legacyInfoState.value.totalTrashCnt}');
  }
}
