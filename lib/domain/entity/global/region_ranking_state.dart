class RegionRankingState {
  final int regionId;
  final String regionName;
  final int score;
  final int ranking;

  RegionRankingState({
    required this.regionId,
    required this.regionName,
    required this.score,
    required this.ranking,
  });

  factory RegionRankingState.fromJson(Map<String, dynamic> json) {
    return RegionRankingState(
      regionId: json['regionId'] ?? 0,
      regionName: json['regionName'] ?? '',
      score: json['score'] ?? 0,
      ranking: json['ranking'] ?? 0,
    );
  }


  RegionRankingState copyWith({
    int? regionId,
    String? regionName,
    int? score,
    int? ranking,
  }) {
    return RegionRankingState(
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      score: score ?? this.score,
      ranking: ranking ?? this.ranking,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regionId': regionId,
      'regionName': regionName,
      'score': score,
      'ranking': ranking,
    };
  }

  @override
  String toString() {
    return 'RegionRankingState(regionId: $regionId, regionName: $regionName, score: $score, ranking: $ranking)';
  }
}