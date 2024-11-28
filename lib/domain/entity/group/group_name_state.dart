class GroupNameState {
  final String teamName;

  GroupNameState({
    required this.teamName,
  });

  GroupNameState copyWith({
    String? teamName,
  }) {
    return GroupNameState(
      teamName: teamName ?? this.teamName,
    );
  }

  factory GroupNameState.initial() {
    return GroupNameState(
      teamName: '',
    );
  }

  factory GroupNameState.fromJson(Map<String, dynamic> json) {
    return GroupNameState(
      teamName: json['team_name'],
    );
  }
}