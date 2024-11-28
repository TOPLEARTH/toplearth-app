class PloggingFinishState {
  final double distance;
  final int duration;
  final int pickUpCnt;
  final int burnedCalories;

  PloggingFinishState({
    required this.distance,
    required this.duration,
    required this.pickUpCnt,
    required this.burnedCalories,
  });

  PloggingFinishState copyWith({
    double? distance,
    int? duration,
    int? pickUpCnt,
    int? burnedCalories,
  }) {
    return PloggingFinishState(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      pickUpCnt: pickUpCnt ?? this.pickUpCnt,
      burnedCalories: burnedCalories ?? this.burnedCalories,
    );
  }

  PloggingFinishState initial() {
    return PloggingFinishState(
      distance: 0.0,
      duration: 0,
      pickUpCnt: 0,
      burnedCalories: 0,
    );
  }

  factory PloggingFinishState.fromJson(Map<String, dynamic> json) {
    return PloggingFinishState(
      distance: double.tryParse(json['distance']?.toString() ?? '0.0') ?? 0.0,
      duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      pickUpCnt: int.tryParse(json['pickUpCnt']?.toString() ?? '0') ?? 0,
      burnedCalories: int.tryParse(json['burnedCalories']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration,
      'pickUpCnt': pickUpCnt,
      'burnedCalories': burnedCalories,
    };
  }
}