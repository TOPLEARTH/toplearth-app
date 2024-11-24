import 'package:toplearth/domain/entity/group/monthly_group_state.dart';

class GroupDetailState {
  final int teamId;
  final String teamName;
  final String teamCode;
  final int matchCnt;
  final int winCnt;
  final Map<String, MonthlyGroupState> monthlyData;

  GroupDetailState({
    required this.teamId,
    required this.teamName,
    required this.teamCode,
    required this.matchCnt,
    required this.winCnt,
    required this.monthlyData,
  });

  factory GroupDetailState.fromJson(Map<String, dynamic> json) {
    return GroupDetailState(
      teamId: json['teamId'],
      teamName: json['teamName'],
      teamCode: json['teamCode'],
      matchCnt: json['matchCnt'],
      winCnt: json['winCnt'],
      monthlyData: (json['teamSelect'] as Map<String, dynamic>).map(
            (month, data) => MapEntry(
          month,
          MonthlyGroupState.fromJson(data),
        ),
      ),
    );
  }
}
