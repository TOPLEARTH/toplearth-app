// import 'package:toplearth/domain/entity/global/legacy_info_state.dart';
// import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
// import 'package:toplearth/domain/entity/group/team_info_state.dart';
// import 'package:toplearth/domain/entity/plogging/plogging_info_state.dart';
// import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
// import 'package:toplearth/domain/entity/user/user_state.dart';
//
// class BootstrapState {
//   // 유저 뷰 상태
//   final UserState userInfo;
//   // MY 퀘스트 뷰 상태
//   final QuestInfoState questInfo;
//   // 그룹 탭 뷰 상태
//   final TeamInfoState teamInfo;
//   final PloggingInfoState ploggingInfo;
//   final LegacyInfoState legacyInfo;
//   final RegionRankingInfoState regionRankingInfo;
//
//   BootstrapState({
//     required this.userInfo,
//     required this.questInfo,
//     required this.teamInfo,
//     required this.ploggingInfo,
//     required this.legacyInfo,
//     required this.regionRankingInfo,
//   });
//
//
//   factory BootstrapState.fromJson(Map<String, dynamic> json) {
//     return BootstrapState(
//       userInfo: UserState.fromJson(json['userInfo']),
//       questInfo: QuestInfoState.fromJson(json['questInfo']),
//       teamInfo: TeamInfoState.fromJson(json['teamInfo']),
//       ploggingInfo: PloggingInfoState.fromJson(json['ploggingInfo']),
//       legacyInfo: LegacyInfoState.fromJson(json['legacyInfo']),
//       regionRankingInfo: RegionRankingInfoState.fromJson(json['regionRankingInfo']),
//     );
//   }
//
//   @override
//   String toString() {
//     return 'BootstrapState(userInfo: $userInfo, questInfo: $questInfo, teamInfo: $teamInfo, ploggingInfo: $ploggingInfo, legacyInfo: $legacyInfo, regionRankingInfo: $regionRankingInfo)';
//   }
// }
import 'package:toplearth/domain/entity/global/legacy_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_info_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';

class BootstrapState {
  final UserState userInfo;
  final QuestInfoState questInfo;
  final TeamInfoState teamInfo;
  final PloggingInfoState ploggingInfo;
  final LegacyInfoState legacyInfo;
  final RegionRankingInfoState regionRankingInfo;

  BootstrapState({
    required this.userInfo,
    required this.questInfo,
    required this.teamInfo,
    required this.ploggingInfo,
    required this.legacyInfo,
    required this.regionRankingInfo,
  });


  factory BootstrapState.fromJson(Map<String, dynamic> json) {
    return BootstrapState(
      userInfo: UserState.fromJson(json['userInfo']),
      questInfo: QuestInfoState.fromJson(json['questInfo']),
      teamInfo: TeamInfoState.fromJson(json['teamInfo']),
      ploggingInfo: PloggingInfoState.fromJson(json['ploggingInfo']),
      legacyInfo: LegacyInfoState.fromJson(json['legacyInfo']),
      regionRankingInfo: RegionRankingInfoState.fromJson(json['regionRankingInfo']),
    );
  }

  @override
  String toString() {
    return 'BootstrapState(userInfo: $userInfo, questInfo: $questInfo, teamInfo: $teamInfo, ploggingInfo: $ploggingInfo, legacyInfo: $legacyInfo, regionRankingInfo: $regionRankingInfo)';
  }
}
