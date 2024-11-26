import 'package:toplearth/domain/entity/group/member_state.dart';
import 'package:toplearth/domain/entity/group/monthly_group_state.dart';

class TeamInfoState {
  final int teamId;
  final String teamName;
  final String teamCode;
  final int matchCnt;
  final int winCnt;
  final List<MemberState> teamMemebers;
  final Map<String, MonthlyGroupState> monthlyData;

  TeamInfoState({
    required this.teamId,
    required this.teamName,
    required this.teamCode,
    required this.matchCnt,
    required this.winCnt,
    required this.teamMemebers,
    required this.monthlyData,
  });

  TeamInfoState copyWith({
    int? teamId,
    String? teamName,
    String? teamCode,
    int? matchCnt,
    int? winCnt,
    List<MemberState>? teamMemebers,
    Map<String, MonthlyGroupState>? monthlyData,
  }) {
    return TeamInfoState(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamCode: teamCode ?? this.teamCode,
      matchCnt: matchCnt ?? this.matchCnt,
      winCnt: winCnt ?? this.winCnt,
      teamMemebers: teamMemebers ?? this.teamMemebers,
      monthlyData: monthlyData ?? this.monthlyData,
    );
  }

  factory TeamInfoState.initial() {
    return TeamInfoState(
      teamId: 0,
      teamName: '',
      teamCode: '',
      matchCnt: 0,
      winCnt: 0,
      teamMemebers: [],
      monthlyData: {},
    );
  }

  factory TeamInfoState.fromJson(Map<String, dynamic> json) {
    return TeamInfoState(
      teamId: json['teamId'],
      teamName: json['teamName'],
      teamCode: json['teamCode'],
      matchCnt: json['matchCnt'],
      winCnt: json['winCnt'],
      teamMemebers: (json['teamMemebers'] as List<dynamic>?)
              ?.map(
                (member) =>
                    MemberState.fromJson(member as Map<String, dynamic>),
              )
              .toList() ??
          [],
      monthlyData: (json['monthlyData'] as Map<String, dynamic>?)?.map(
            (month, data) => MapEntry(
              month,
              MonthlyGroupState.fromJson(data as Map<String, dynamic>),
            ),
          ) ??
          {},
    );
  }

  @override
  String toString() {
    return 'TeamInfoState(teamId: $teamId, teamName: $teamName, '
        'teamCode: $teamCode, matchCnt: $matchCnt, winCnt: $winCnt, '
        'teamMemebers: $teamMemebers, monthlyData: $monthlyData)';
  }
}
