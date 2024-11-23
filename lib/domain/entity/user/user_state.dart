class UserState {
  final String id;
  final String nickname;
  final String email;
  final String fcmToken;
  // dummy
  final int daysTogether;
  final double currentProgress;
  final int lastWeekSessions;
  final int lastWeekDuration;
  final int lastWeekCalories;


  const UserState({
    required this.id,
    required this.nickname,
    required this.email,
    required this.fcmToken,
    required this.daysTogether,
    required this.currentProgress,
    required this.lastWeekSessions,
    required this.lastWeekDuration,
    required this.lastWeekCalories,
  });

  factory UserState.initial() {
    return const UserState(
      id: '',
      nickname: '규진',
      email: '',
      fcmToken: '',
      daysTogether: 2000,
      currentProgress: 0.75,
      lastWeekSessions: 200,
      lastWeekDuration: 100,
      lastWeekCalories: 4000,
    );
  }

  UserState copyWith({
    String? id,
    String? nickname,
    String? email,
    String? fcmToken,
    int? daysTogether,
    double? currentProgress,
    int? lastWeekSessions,
    int? lastWeekDuration,
    int? lastWeekCalories,
  }) {
    return UserState(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      daysTogether: daysTogether ?? this.daysTogether,
      currentProgress: currentProgress ?? this.currentProgress,
      lastWeekSessions: lastWeekSessions ?? this.lastWeekSessions,
      lastWeekDuration: lastWeekDuration ?? this.lastWeekDuration,
      lastWeekCalories: lastWeekCalories ?? this.lastWeekCalories,
    );
  }


  factory UserState.fromJson(Map<String, dynamic> data) {
    return UserState(
      id: data['id'],
      nickname: data['nickname'],
      email: data['email'],
      fcmToken: data['fcmToken'],
      daysTogether: data['daysTogether'],
      currentProgress: data['currentProgress'],
      lastWeekSessions: data['lastWeekSessions'],
      lastWeekDuration: data['lastWeekDuration'],
      lastWeekCalories: data['lastWeekCalories'],
    );
  }

  @override
  String toString() {
    return 'UserBriefState(id: $id, nickname: $nickname, email: $email, fcmToken: $fcmToken)';
  }
}
