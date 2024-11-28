import 'package:toplearth/domain/entity/plogging/plogging_state.dart';

class PloggingInfoState {
  final Map<String, List<PloggingState>> ploggingList;

  const PloggingInfoState({
    required this.ploggingList,
  });

  /// Initial state with an empty map
  factory PloggingInfoState.initial() {
    return const PloggingInfoState(
      ploggingList: {},
    );
  }

  /// Copy method to create a new instance with modified values
  PloggingInfoState copyWith({
    Map<String, List<PloggingState>>? ploggingList,
  }) {
    return PloggingInfoState(
      ploggingList: ploggingList ?? this.ploggingList,
    );
  }

  /// Factory method to parse JSON into a `PloggingInfoState`
  factory PloggingInfoState.fromJson(Map<String, dynamic> json) {
    final ploggingListData =
        json['ploggingList'] as Map<String, dynamic>? ?? {};

    // Parse each date's list of ploggings into a Map<String, List<PloggingState>>
    final parsedPloggingList = ploggingListData.map((date, ploggings) {
      final ploggingStates = (ploggings as List<dynamic>)
          .map((plogging) => PloggingState.fromJson(plogging))
          .toList();
      return MapEntry(date, ploggingStates);
    });

    return PloggingInfoState(ploggingList: parsedPloggingList);
  }

  @override
  String toString() {
    return 'PloggingInfoState{ploggingList: $ploggingList}';
  }
}
