class LabelState {
  final String label;
  final int count;

  LabelState({
    required this.label,
    required this.count,
  });

  LabelState copyWith({
    String? label,
    int? count,
  }) {
    return LabelState(
      label: label ?? this.label,
      count: count ?? this.count,
    );
  }

  LabelState initial() {
    return LabelState(
      label: '',
      count: 0,
    );
  }

  factory LabelState.fromJson(Map<String, dynamic> json) {
    return LabelState(
      label: json['label'],
      count: json['count'],
    );
  }
}
