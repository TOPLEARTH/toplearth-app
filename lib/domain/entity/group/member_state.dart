class MemberState {
  final int id;
  final String name;
  final String role;
  final double distance;
  final bool isActive;

  MemberState({
    required this.id,
    required this.name,
    required this.role,
    required this.distance,
    required this.isActive,
  });

  MemberState copyWith({
    int? id,
    String? name,
    String? role,
    double? distance,
    bool? isActive,
  }) {
    return MemberState(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      distance: distance ?? this.distance,
      isActive: isActive ?? this.isActive,
    );
  }

  factory MemberState.fromJson(Map<String, dynamic> json) {
    return MemberState(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? false,
    );
  }
}