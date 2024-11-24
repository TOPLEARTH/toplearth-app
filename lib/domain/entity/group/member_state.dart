class MemberState {
  final int id;
  final String name;
  final String role;
  final double distance;

  MemberState({
    required this.id,
    required this.name,
    required this.role,
    required this.distance,
  });

  MemberState copyWith({
    int? id,
    String? name,
    String? role,
    double? distance,
  }) {
    return MemberState(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      distance: distance ?? this.distance,
    );
  }

  MemberState initial() {
    return MemberState(
      id: 0,
      name: '',
      role: '',
      distance: 0.0,
    );
  }

  factory MemberState.fromJson(Map<String, dynamic> json) {
    return MemberState(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      distance: (json['distance'] as num).toDouble(),
    );
  }
}
