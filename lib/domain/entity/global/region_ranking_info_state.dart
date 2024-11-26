import 'package:toplearth/domain/entity/global/region_ranking_state.dart';

class RegionRankingInfoState {
  final List<RegionRankingState> regionRankingInfo;

  RegionRankingInfoState({
    required this.regionRankingInfo,
  });

  RegionRankingInfoState copyWith({
    List<RegionRankingState>? regionRankingInfo,
  }) {
    return RegionRankingInfoState(
      regionRankingInfo: regionRankingInfo ?? this.regionRankingInfo,
    );
  }

  factory RegionRankingInfoState.initial() {
    return RegionRankingInfoState(
      regionRankingInfo: [],
    );
  }


  factory RegionRankingInfoState.fromJson(List<dynamic> json) {
    return RegionRankingInfoState(
      regionRankingInfo: json.map((regionRanking) => RegionRankingState.fromJson(regionRanking)).toList(),
    );
  }
}