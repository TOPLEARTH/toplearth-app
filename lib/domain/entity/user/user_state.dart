class UserState {
  final String userId;
  final String socialId;
  final String nickname;
  final double totalKilometers;
  final double targetKilometers;
  final int creditInfo;
  final bool isJoinedTeam;

  const UserState({
    required this.userId,
    required this.socialId,
    required this.nickname,
    required this.totalKilometers,
    required this.targetKilometers,
    required this.creditInfo,
    required this.isJoinedTeam,
  });

  factory UserState.initial() {
    return const UserState(
      userId: '',
      socialId: '',
      nickname: '',
      totalKilometers: 0.0,
      targetKilometers: 0.0,
      creditInfo: 0,
      isJoinedTeam: false,
    );
  }

  UserState copyWith({
    String? userId,
    String? socialId,
    String? nickname,
    double? totalKilometers,
    double? targetKilometers,
    int? creditInfo,
    bool? isJoinedTeam,
  }) {
    return UserState(
      userId: userId ?? this.userId,
      socialId: socialId ?? this.socialId,
      nickname: nickname ?? this.nickname,
      totalKilometers: totalKilometers ?? this.totalKilometers,
      targetKilometers: targetKilometers ?? this.targetKilometers,
      creditInfo: creditInfo ?? this.creditInfo,
      isJoinedTeam: isJoinedTeam ?? this.isJoinedTeam,
    );
  }

  factory UserState.fromJson(Map<String, dynamic> data) {
    return UserState(
      userId: data['userId'] ?? '',
      socialId: data['socialId'] ?? '',
      nickname: data['nickname'] ?? '',
      totalKilometers: double.tryParse(data['totalKilometers']?.toString() ?? '0') ?? 0.0,
      targetKilometers: double.tryParse(data['targetKilometers']?.toString() ?? '0') ?? 0.0,
      creditInfo: int.tryParse(data['creditInfo']?.toString() ?? '0') ?? 0,
      isJoinedTeam: data['isJoinedTeam'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserState{userId: $userId, socialId: $socialId, nickname: $nickname, totalKilometers: $totalKilometers, targetKilometers: $targetKilometers, creditInfo: $creditInfo, isJoinedTeam: $isJoinedTeam}';
  }
}
