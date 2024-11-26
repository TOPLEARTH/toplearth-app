import 'dart:core';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/utility/notification_util.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/global/legacy_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_info_state.dart';
import 'package:toplearth/domain/entity/plogging/team_info_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/domain/entity/user/boot_strap_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';
import 'package:toplearth/domain/usecase/user/read_user_state_usecase.dart';

class RootViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const duration = Duration(milliseconds: 200);

  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final ReadBootStrapUseCase _readBootStrapUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late Rx<DateTime> _currentAt;
  late final RxInt _selectedIndex;
  late final Rx<UserState> _userState;
  late final Rx<QuestInfoState> _questInfoState;
  late final Rx<TeamInfoState> _teamInfoState;
  late final Rx<PloggingInfoState> _ploggingInfoState;
  late final Rx<LegacyInfoState> _legacyInfoState;
  late final Rx<RegionRankingInfoState> _regionRankingInfoState;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // DateTime get currentAt => _currentAt.value;
  int get selectedIndex => _selectedIndex.value;

  UserState get userState => _userState.value;
  QuestInfoState get questInfoState => _questInfoState.value;
  TeamInfoState get teamInfoState => _teamInfoState.value;
  PloggingInfoState get ploggingInfoState => _ploggingInfoState.value;
  LegacyInfoState get legacyInfoState => _legacyInfoState.value;
  RegionRankingInfoState get regionRankingInfoState => _regionRankingInfoState.value;

  RxBool isBootstrapLoaded = false.obs;

  @override
  void onInit() async {
    super.onInit();

    // Dependency Injection
    _readBootStrapUseCase = Get.find<ReadBootStrapUseCase>();

    _userState = UserState.initial().obs;
    _questInfoState = QuestInfoState.initial().obs;
    _teamInfoState = TeamInfoState.initial().obs;
    _ploggingInfoState = PloggingInfoState.initial().obs;
    _legacyInfoState = LegacyInfoState.initial().obs;
    _regionRankingInfoState = RegionRankingInfoState.initial().obs;

    _selectedIndex = 2.obs;

    // FCM Setting
    FirebaseMessaging.onMessage
        .listen(NotificationUtil.showFlutterNotification);
    FirebaseMessaging.onBackgroundMessage(NotificationUtil.onBackgroundHandler);

    // Private Fields
    _currentAt = DateTime.now().obs;
  }

  void changeIndex(int index) async {
    _selectedIndex.value = index;
    _currentAt.value = DateTime.now();
  }

  @override
  void onReady() async {
    _fetchBootstrapInformation();
    super.onReady();


  }

  void _fetchBootstrapInformation() async {
    StateWrapper<BootstrapState> state = await _readBootStrapUseCase.execute();

    if (state.success) {
      _userState.value = state.data!.userInfo;
      _questInfoState.value = state.data!.questInfo;
      _teamInfoState.value = state.data!.teamInfo!;
      _ploggingInfoState.value = state.data!.ploggingInfo;
      _legacyInfoState.value = state.data!.legacyInfo;
      _regionRankingInfoState.value = state.data!.regionRankingInfo;

      debugPrint('userState: ${_userState.value.nickname}');

      debugPrint('legacyInfoState: ${_legacyInfoState.value.totalTrashCnt}');

      isBootstrapLoaded.value = true; // 로드 완료 상태 업데이트
    }
    debugPrint('isBootstrapLoaded: ${isBootstrapLoaded.value}');
  }
}
