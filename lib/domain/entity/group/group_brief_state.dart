class GroupBriefState {
  final int teamId;
  final String teamName;
  final String teamCode;

  GroupBriefState({
    required this.teamId,
    required this.teamName,
    required this.teamCode,
  });

  GroupBriefState copyWith({
    int? teamId,
    String? teamName,
    String? teamCode,
  }) {
    return GroupBriefState(
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamCode: teamCode ?? this.teamCode,
    );
  }

  factory GroupBriefState.initial() {
    return GroupBriefState(
      teamId: 0,
      teamName: '',
      teamCode: '',
    );
  }

  factory GroupBriefState.fromJson(Map<String, dynamic> json) {
    return GroupBriefState(
      teamId: json['team_id'],
      teamName: json['team_name'],
      teamCode: json['team_code'],
    );
  }
}
