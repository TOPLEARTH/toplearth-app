class PloggingTeamInfoState {
  final int teamId;
  final String teamName;
  final int opponentTeamId;
  final String opponentTeamName;

  const PloggingTeamInfoState({
    required this.teamId,
    required this.teamName,
    required this.opponentTeamId,
    required this.opponentTeamName,
  });

  factory PloggingTeamInfoState.fromJson(Map<String, dynamic> json) {
    return PloggingTeamInfoState(
      teamId: int.tryParse(json['teamId']?.toString() ?? '0') ?? 0,
      teamName: json['teamName'] ?? '',
      opponentTeamId: int.tryParse(json['opponentTeamId']?.toString() ?? '0') ?? 0,
      opponentTeamName: json['opponentTeamName'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TeamInfoState(teamId: $teamId, teamName: $teamName, opponentTeamId: $opponentTeamId, opponentTeamName: $opponentTeamName)';
  }
}
