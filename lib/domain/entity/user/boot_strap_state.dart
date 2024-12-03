import 'package:toplearth/domain/entity/global/legacy_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/entity/home/home_info_state.dart';
import 'package:toplearth/domain/entity/matching/matching_real_time_info_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_info_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';

class BootstrapState {
  final UserState userInfo;
  final QuestInfoState questInfo;
  final TeamInfoState teamInfo; // nullable로 변경
  final MatchingRealTimeInfoState? matchingRealTimeInfo; // nullable로 변경
  final PloggingInfoState ploggingInfo;
  final LegacyInfoState legacyInfo;
  final RegionRankingInfoState regionRankingInfo;
  final HomeInfoState homeInfo;
  BootstrapState({
    required this.userInfo,
    required this.questInfo,
    required this.teamInfo,
    this.matchingRealTimeInfo,
    required this.ploggingInfo,
    required this.legacyInfo,
    required this.regionRankingInfo,
    required this.homeInfo,
  });

  factory BootstrapState.fromJson(Map<String, dynamic> json) {
    return BootstrapState(
      userInfo: UserState.fromJson(json['userInfo']),
      questInfo: QuestInfoState.fromJson(json['questInfo']),
      teamInfo: TeamInfoState.fromJson(json['teamInfo']),
      matchingRealTimeInfo: json['matchingRealTimeInfo'] != null // null 체크 추가
          ? MatchingRealTimeInfoState.fromJson(json['matchingRealTimeInfo'])
          : MatchingRealTimeInfoState.initial(),
      ploggingInfo: PloggingInfoState.fromJson(json['ploggingInfo']),
      legacyInfo: LegacyInfoState.fromJson(json['legacyInfo']),
      regionRankingInfo:
          RegionRankingInfoState.fromJson(json['regionRankingInfo']),
      homeInfo: HomeInfoState.fromJson(json['homeInfo']),
    );
  }

  @override
  String toString() {
    return 'BootstrapState(userInfo: $userInfo, questInfo: $questInfo,  teamInfo: $teamInfo, matchingRealTimeInfo: $matchingRealTimeInfo, ploggingInfo: $ploggingInfo, legacyInfo: $legacyInfo, regionRankingInfo: $regionRankingInfo, homeInfo: $homeInfo)';
  }
}
