class UserBriefState {
  final String id;
  final String nickname;
  final String email;


  const UserBriefState({
    required this.id,
    required this.nickname,
    required this.email,
  });

  UserBriefState copyWith({
    String? id,
    String? nickname,
    String? email,
  }) {
    return UserBriefState(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
    );
  }

  factory UserBriefState.initial() {
    return const UserBriefState(
      id: '',
      nickname: '',
      email: '',
    );
  }
}
