class JoinGroupCondition {
  final int teamId;

  JoinGroupCondition({
    required this.teamId,
  });

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
    };
  }
}