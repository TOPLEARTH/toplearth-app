class LeaveGroupCondition {
  final int teamId;

  LeaveGroupCondition({
    required this.teamId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teamId'] = teamId;
    return data;
  }
}