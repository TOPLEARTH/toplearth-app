import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/matching/matching_remote_provider.dart';
import 'package:toplearth/domain/condition/matching/designated_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/end_vs_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/random_matching_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/entity/plogging/recent_matching_info_state.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';

class MatchingRepositoryImpl extends GetxService implements MatchingRepository {
  late final MatchingRemoteProvider _matchingRemoteProvider;

  @override
  void onInit() {
    super.onInit();
    _matchingRemoteProvider = Get.find<MatchingRemoteProvider>();
  }

  @override
  Future<StateWrapper<MatchingStatusState>> requestRandomMatching(
      RandomMatchingCondition condition) async {
    ResponseWrapper response = await _matchingRemoteProvider
        .requestRandomMatching(teamId: condition.teamId);

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }
    MatchingStatusState state = MatchingStatusState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }

  @override
  Future<StateWrapper<void>> requestDesignatedMatching(
      DesignatedMatchingCondition condition) async {
    ResponseWrapper response =
        await _matchingRemoteProvider.requestDesignatedMatching(
            teamId: condition.teamId, opponentTeamId: condition.opponentTeamId);

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  @override
  Future<StateWrapper<void>> endMatching() async {
    ResponseWrapper response = await _matchingRemoteProvider.endMatching();

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  @override
  Future<StateWrapper<MatchingStatusState>> endVsMatching(
      EndVsMatchingCondition condition) async {
    ResponseWrapper response = await _matchingRemoteProvider.endVsMatching(
      matchingId: condition.matchingId,
      competitionScore: condition.competitionScore,
      totalPickUpCnt: condition.totalPickUpCnt,
      winFlag: condition.winFlag,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }
    MatchingStatusState state = MatchingStatusState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }

  @override
  Future<StateWrapper<MatchingStatusState>> getMatchingStatus() async {
    ResponseWrapper response =
        await _matchingRemoteProvider.getMatchingStatus();

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }
    MatchingStatusState state = MatchingStatusState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }

  /// 점검 필요
  @override
  Future<StateWrapper<RecentMatchingInfoState>> getRecentPlogging() async {
    ResponseWrapper response =
        await _matchingRemoteProvider.getRecentPlogging();

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }
    RecentMatchingInfoState state =
        RecentMatchingInfoState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }
}
