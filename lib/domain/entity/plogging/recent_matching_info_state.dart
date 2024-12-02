import 'package:toplearth/domain/entity/plogging/plogging_recent.state.dart';

class RecentMatchingInfoState {
  final List<PloggingRecentState> recentMatchingInfo;

  RecentMatchingInfoState({required this.recentMatchingInfo});

  RecentMatchingInfoState copyWith({
    List<PloggingRecentState>? recentMatchingInfo,
  }) {
    return RecentMatchingInfoState(
      recentMatchingInfo: recentMatchingInfo ?? this.recentMatchingInfo,
    );
  }

  factory RecentMatchingInfoState.fromJson(Map<String, dynamic> json) {
    return RecentMatchingInfoState(
      recentMatchingInfo: (json['recentMatchingInfo'] as List<dynamic>)
          .map((item) => PloggingRecentState.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recentMatchingInfo': recentMatchingInfo.map((e) => e.toJson()).toList(),
    };
  }
}
