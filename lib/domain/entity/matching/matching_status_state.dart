import 'package:toplearth/domain/type/e_matching_status.dart';

class MatchingStatusState {
  final EMatchingStatus status;

  MatchingStatusState({
    required this.status,
  });

  MatchingStatusState copyWith({
    EMatchingStatus? status,
  }) {
    return MatchingStatusState(
      status: status ?? this.status,
    );
  }

  MatchingStatusState initial() {
    return MatchingStatusState(
      status: EMatchingStatus.WAITING,
    );
  }


  factory MatchingStatusState.fromJson(Map<String, dynamic> json) {
    return MatchingStatusState(
      status: EMatchingStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () {
          // 기본 상태 반환 (예: WAITING)
          return EMatchingStatus.WAITING;
        },
      ),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
    };
  }
}