import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/matching/designated_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/random_matching_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/type/e_group_status.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/domain/usecase/matching/matching_by_designated_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_by_random_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_finish_usecase.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class MatchingGroupViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* DI Fields -------------------------------------------- */
  /* ------------------------------------------------------ */
  late final MatchingByRandomUseCase _matchingByRandomUseCase;
  late final MatchingByDesignatedUseCase _matchingByDesignatedUseCase;
  late final MatchingFinishUseCase _matchingFinishUsecase;
  late final RootViewModel _rootViewModel;

  /* ------------------------------------------------------ */
  /* Managed State ---------------------------------------- */
  /* ------------------------------------------------------ */
  late final RxInt teamId = 0.obs; // 관리되는 팀 ID
  late final RxInt opponentTeamId = 0.obs; // 관리되는 상대 팀 ID
  late final Rx<EMatchingStatus> matchingStatus = EMatchingStatus.WAITING.obs;

  /* ------------------------------------------------------ */
  /* Lifecycle Methods ------------------------------------ */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();
    _rootViewModel = Get.find<RootViewModel>();
    _matchingByDesignatedUseCase = Get.find<MatchingByDesignatedUseCase>();
    _matchingByRandomUseCase = Get.find<MatchingByRandomUseCase>();
    _matchingFinishUsecase = Get.find<MatchingFinishUseCase>();

    // 매칭 상태 업데이트
    ever(_rootViewModel.matchingStatusState,
        (MatchingStatusState newMatchingStatusState) {
      switch (newMatchingStatusState.status) {
        case EMatchingStatus.NOTJOINED:
          matchingStatus.value = EMatchingStatus.NOTJOINED;
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
        case EMatchingStatus.FINISHED:
          matchingStatus.value = EMatchingStatus.FINISHED;
          break;
        default:
          matchingStatus.value = EMatchingStatus.WAITING;
          break;
      }
    });
  }

  /* ------------------------------------------------------ */
  /* Public Methods --------------------------------------- */
  /* ------------------------------------------------------ */
  /// 랜덤 매칭 요청
  Future<ResultWrapper> requestRandomMatching() async {
    if (teamId.value == 0) {
      return ResultWrapper(
        success: false,
        message: "팀 ID가 설정되지 않았습니다.",
      );
    }

    StateWrapper<void> state = await _matchingByRandomUseCase
        .execute(RandomMatchingCondition(teamId: teamId.value));

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
    StateWrapper<void> state = await _matchingFinishUsecase.execute();
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

  /// 매칭 상태 변경 시뮬레이션
  void simulateStatusChange(EMatchingStatus status) {
    matchingStatus.value = status;
  }
}
