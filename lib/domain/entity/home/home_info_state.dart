class HomeInfoState {
  final int joinedTime;
  final int ploggingMonthlyCount;
  final int ploggingMonthlyDuration;
  final int burnedCalories;
  HomeInfoState({
    required this.joinedTime,
    required this.ploggingMonthlyCount,
    required this.ploggingMonthlyDuration,
    required this.burnedCalories,
  });

  // 초기 상태 (기본값)
  factory HomeInfoState.initial() {
    return HomeInfoState(
      joinedTime: 0,
      ploggingMonthlyCount: 0,
      ploggingMonthlyDuration: 0,
      burnedCalories: 0,
    );
  }

  // JSON 데이터를 통해 상태를 생성
  factory HomeInfoState.fromJson(Map<String, dynamic> json) {
    return HomeInfoState(
      joinedTime: json['joinedTime'] ?? 0,
      ploggingMonthlyCount: json['ploggingMonthlyCount'] ?? 0,
      ploggingMonthlyDuration: json['ploggingMonthlyDuration'] ?? 0,
      burnedCalories: json['burnedCalories'] ?? 0,
    );
  }
}
