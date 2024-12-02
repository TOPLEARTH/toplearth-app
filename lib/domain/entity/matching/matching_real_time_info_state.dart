import 'package:toplearth/domain/type/e_matching_status.dart';

class MatchingRealTimeInfoState {
  final DateTime? matchingStartedAt;
  final String? ourTeamName;
  final String? opponentTeamName;

  MatchingRealTimeInfoState({
    this.matchingStartedAt,
    this.ourTeamName,
    this.opponentTeamName,
  });

  MatchingRealTimeInfoState copyWith({
    DateTime? matchingStartedAt,
    String? ourTeamName,
    String? opponentTeamName,
  }) {
    return MatchingRealTimeInfoState(
      matchingStartedAt: matchingStartedAt ?? this.matchingStartedAt,
      ourTeamName: ourTeamName ?? this.ourTeamName,
      opponentTeamName: opponentTeamName ?? this.opponentTeamName,
    );
  }

  factory MatchingRealTimeInfoState.initial() {
    return MatchingRealTimeInfoState(
      matchingStartedAt: null,
      ourTeamName: '',
      opponentTeamName: '',
    );
  }

  factory MatchingRealTimeInfoState.fromJson(Map<String, dynamic> json) {
    return MatchingRealTimeInfoState(
      matchingStartedAt: json['matchingStartedAt'] != null
          ? DateTime.parse(json['matchingStartedAt'])
          : null,
      ourTeamName: json['ourTeamName'],
      opponentTeamName: json['opponentTeamName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchingStartedAt': matchingStartedAt?.toIso8601String(),
      'ourTeamName': ourTeamName,
      'opponentTeamName': opponentTeamName,
    };
  }
}
