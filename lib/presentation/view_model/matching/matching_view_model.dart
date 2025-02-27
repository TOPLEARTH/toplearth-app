import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/utility/log_util.dart';
import 'package:toplearth/core/provider/base_socket.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/matching/designated_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/end_vs_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/random_matching_condition.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/entity/plogging/recent_matching_info_state.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/domain/usecase/matching/matching_by_designated_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_by_random_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_finish_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_recent_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_status_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_vs_finish_usecase.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class MatchingGroupViewModel extends GetxController {
  late final WebSocketController _webSocketController;
  /* ------------------------------------------------------ */
  /* DI Fields -------------------------------------------- */
  /* ------------------------------------------------------ */
  late final MatchingByRandomUseCase _matchingByRandomUseCase;
  late final MatchingByDesignatedUseCase _matchingByDesignatedUseCase;
  late final MatchingFinishUseCase _matchingFinishUseCase;
  late final MatchingStatusUseCase _matchingStatusUseCase;
  late final MatchingVsFinishUseCase _matchingVsFinishUseCase;
  late final MatchingRecentPloggingUseCase _matchingRecentPloggingUseCase;
  late final RootViewModel _rootViewModel;
  Rx<Duration> countdownTime = Duration(minutes: 10).obs;

  /* ------------------------------------------------------ */
  /* Managed State ---------------------------------------- */
  /* ------------------------------------------------------ */
  late final RxInt teamId = 0.obs;
  late final Rx<TeamInfoState> teamInfoState = TeamInfoState.initial().obs;

  late final RxInt opponentTeamId = 0.obs; // 관리되는 상대 팀 ID
  late final RxString opponentTeamName = "".obs; // 관리되는 상대 팀 이름
  late final Rx<EMatchingStatus> matchingStatus = EMatchingStatus.DEFAULT.obs;
  late final Rx<RecentMatchingInfoState> recentPloggingList =
      RecentMatchingInfoState(recentMatchingInfo: []).obs;
  RxBool isWebSocketConnected = false.obs;
  /* ------------------------------------------------------ */
  /* Lifecycle Methods ------------------------------------ */
  /* ------------------------------------------------------ */

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTime.value > const Duration(seconds: 0)) {
        countdownTime.value -= const Duration(seconds: 1);
      } else {
        timer.cancel(); // Stop the timer when the countdown reaches 0
      }
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _rootViewModel = Get.find<RootViewModel>();

    // DI 주입
    _matchingByRandomUseCase = Get.find<MatchingByRandomUseCase>();
    _matchingByDesignatedUseCase = Get.find<MatchingByDesignatedUseCase>();
    _matchingFinishUseCase = Get.find<MatchingFinishUseCase>();
    _matchingStatusUseCase = Get.find<MatchingStatusUseCase>();
    _matchingVsFinishUseCase = Get.find<MatchingVsFinishUseCase>();
    _matchingRecentPloggingUseCase = Get.find<MatchingRecentPloggingUseCase>();

    final rootViewModel = Get.find<RootViewModel>();

    // RootViewModel에서 teamInfoState 상태 구독
    teamId.value = rootViewModel.teamInfoState.value.teamId ?? 0; // 초기값 설정
    teamInfoState.value =
        rootViewModel.teamInfoState.value; // teamInfoState 초기값 동기화

    debugPrint('MatchingGroupViewModel: 초기 teamId: ${teamId.value}');
    debugPrint(
        'MatchingGroupViewModel: 초기 teamInfoState: ${teamInfoState.value}');

    // teamInfoState 변경 시 동기화
    ever(rootViewModel.teamInfoState, (TeamInfoState updatedTeamInfoState) {
      teamId.value = updatedTeamInfoState.teamId ?? 0;
      teamInfoState.value = updatedTeamInfoState;

      debugPrint(
          'MatchingGroupViewModel: teamInfoState 업데이트: $updatedTeamInfoState');
      debugPrint('MatchingGroupViewModel: teamId 업데이트: ${teamId.value}');
    });

    // Fetch recent plogging information
    await getRecentPlogging();

    // 매칭 상태 업데이트 구독
    ever(_rootViewModel.matchingStatusState,
        (MatchingStatusState newMatchingStatusState) {
      debugPrint('MatchingViewModel 상태 감지: ${newMatchingStatusState.status}');
      switch (newMatchingStatusState.status) {
        case EMatchingStatus.NOT_JOINED:
          matchingStatus.value = EMatchingStatus.NOT_JOINED;
          break;
        case EMatchingStatus.DEFAULT:
          matchingStatus.value = EMatchingStatus.DEFAULT;
          break;
        case EMatchingStatus.WAITING:
          matchingStatus.value = EMatchingStatus.WAITING;
          break;
        case EMatchingStatus.MATCHED:
          matchingStatus.value = EMatchingStatus.MATCHED;
          break;
        case EMatchingStatus.PLOGGING:
          matchingStatus.value = EMatchingStatus.PLOGGING;
          break;
        case EMatchingStatus.FINISHED:
          matchingStatus.value = EMatchingStatus.FINISHED;
          break;
        default:
          matchingStatus.value = EMatchingStatus.WAITING;
          break;
      }
    });

    super.onInit();

    // // WebSocketController 초기화 및 연결
    // _webSocketController = Get.put(WebSocketController());
    // _webSocketController.connectToWebSocket();
    //
    // // WebSocket 연결 상태 구독
    // _webSocketController.isConnected.listen((isConnected) {
    //   if (isConnected) {
    //     print("WebSocket 연결 성공");
    //   } else {
    //     print("WebSocket 연결 해제");
    //   }
    // });
  }

  /* ------------------------------------------------------ */
  /* Public Methods --------------------------------------- */
  /* ------------------------------------------------------ */

  // /// 플로깅 정보 publish
  // void subscribeToMatchingUpdates(int matchingId) {
  //   _webSocketController.subscribeToChannel(
  //     destination: "/pub/plogging/.$matchingId",
  //     onMessage: (message) {
  //       print("수신한 메시지: $message");
  //     },
  //   );
  // }
  //
  // /// 플로깅 정보 subscribe
  // void sendMatchingRequest(int matchingId) {
  //   _webSocketController.sendMessage(
  //     destination: "/sub/plogging/.$matchingId",
  //     body: {"matchingId": matchingId},
  //   );
  // }

  /// 매칭 상태 반환
  @override
  Future<ResultWrapper> getMatchingStatus() async {
    StateWrapper<MatchingStatusState> state =
        await _matchingStatusUseCase.execute();
    _rootViewModel.matchingStatusState.value =
        MatchingStatusState(status: state.data!.status);
    print('매칭 상태@@@@@@@@@@@: ${state.data!.status}');
    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  Future<ResultWrapper> getRecentPlogging() async {
    StateWrapper<RecentMatchingInfoState> state =
        await _matchingRecentPloggingUseCase.execute();

    if (state.success && state.data != null) {
      // 상태를 업데이트
      LogUtil.debug("현재 최근 플로깅 데이터 존재합니다");
      recentPloggingList.value = state.data!;
      LogUtil.debug(state.data);
    } else {
      // 빈 리스트로 초기화
      recentPloggingList.value =
          RecentMatchingInfoState(recentMatchingInfo: []);
    }

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  setMatchingStatus(EMatchingStatus status) {
    matchingStatus.value = status;
  }

  /// 대결 종료 요청
  Future<ResultWrapper> finishVsMatching(
    int matchingId,
    int competitionScore,
    int totalPickUpCnt,
    bool winFlag,
  ) async {
    StateWrapper<MatchingStatusState> state =
        await _matchingVsFinishUseCase.execute(
      EndVsMatchingCondition(
          matchingId: matchingId,
          competitionScore: competitionScore,
          totalPickUpCnt: totalPickUpCnt,
          winFlag: winFlag),
    );
    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  /// 랜덤 매칭 요청
  Future<ResultWrapper> requestRandomMatching() async {
    if (teamId.value == 0) {
      return ResultWrapper(
        success: false,
        message: "팀 ID가 설정되지 않았습니다.",
      );
    }

    print('deubt: ${teamId.value}');

    StateWrapper<MatchingStatusState> state = await _matchingByRandomUseCase
        .execute(RandomMatchingCondition(teamId: teamId.value));
    _rootViewModel.matchingStatusState.value = MatchingStatusState(
      status: state.data!.status,
    );

    print('sibal: ${state.data!.status}');

    print("랜덤 매칭 요청 성공: ${state.data!.status}");
    _rootViewModel.matchingStatusState.value =
        MatchingStatusState(status: state.data!.status);

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  /// 지정 매칭 요청
  Future<ResultWrapper> requestDesignatedMatching() async {
    if (teamId.value == 0 || opponentTeamId.value == 0) {
      return ResultWrapper(
        success: false,
        message: "팀 ID 또는 상대 팀 ID가 설정되지 않았습니다.",
      );
    }

    StateWrapper<void> state = await _matchingByDesignatedUseCase.execute(
      DesignatedMatchingCondition(
        opponentTeamId: opponentTeamId.value,
        teamId: teamId.value,
      ),
    );

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  /// 매칭 종료 요청
  Future<ResultWrapper> finishMatching() async {
    StateWrapper<void> state = await _matchingFinishUseCase.execute();
    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }

  /// 팀 ID 설정
  void setTeamId(int id) {
    teamId.value = id;
  }

  /// 상대 팀 ID 설정
  void setOpponentTeamId(int id) {
    opponentTeamId.value = id;
  }

  void setOpponentTeamName(String name) {
    opponentTeamName.value = name;
  }

  /// 매칭 상태 변경 시뮬레이션
  void simulateStatusChange(EMatchingStatus status) {
    matchingStatus.value = status;
  }
}
