import 'package:toplearth/domain/type/e_matching_status.dart';

class MatchingStatusState {
  final EMatchingStatus matchingStatus;

  MatchingStatusState({
    required this.matchingStatus,
  });

  MatchingStatusState copyWith({
    EMatchingStatus? matchingStatus,
  }) {
    return MatchingStatusState(
      matchingStatus: matchingStatus ?? this.matchingStatus,
    );
  }

  MatchingStatusState initial() {
    return MatchingStatusState(
      matchingStatus: EMatchingStatus.WAITING,
    );
  }


  factory MatchingStatusState.fromJson(Map<String, dynamic> json) {
    return MatchingStatusState(
      matchingStatus: EMatchingStatus.values.firstWhere((e) => e.toString() == json['matchingStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchingStatus': matchingStatus.toString(),
    };
  }
}