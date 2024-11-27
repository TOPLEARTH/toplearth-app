class PloggingStartIndividualState{
  final int ploggingId;

  PloggingStartIndividualState({
    required this.ploggingId,
  });

  PloggingStartIndividualState copyWith({
    int? ploddingId,
  }) {
    return PloggingStartIndividualState(
      ploggingId: ploddingId ?? this.ploggingId,
    );
  }

  PloggingStartIndividualState initial() {
    return PloggingStartIndividualState(
      ploggingId: 0,
    );
  }

  factory PloggingStartIndividualState.fromJson(Map<String, dynamic> json) {
    return PloggingStartIndividualState(
      ploggingId: int.tryParse(json['ploggingId']?.toString() ?? '0') ?? 0,
    );
  }
}