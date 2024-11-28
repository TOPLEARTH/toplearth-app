class GroupCreateState {
  final String name;
  final String code;

  GroupCreateState({
    required this.name,
    required this.code,
  });

  GroupCreateState copyWith({
    String? name,
    String? code,
  }) {
    return GroupCreateState(
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  GroupCreateState initial() {
    return GroupCreateState(
      name: '',
      code: '',
    );
  }

  factory GroupCreateState.fromJson(Map<String, dynamic> json) {
    return GroupCreateState(
      name: json['name'],
      code: json['code'],
    );
  }
}