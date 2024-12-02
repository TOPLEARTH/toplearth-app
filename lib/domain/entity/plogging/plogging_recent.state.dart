import 'package:toplearth/domain/entity/plogging/plogging_image_state.dart';

class PloggingRecentState {
  final int ploggingId;
  final String teamName;
  final double distance;
  final int duration;
  final int trashCnt;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<PloggingImageState> ploggingImageList;

  PloggingRecentState({
    required this.ploggingId,
    required this.teamName,
    required this.distance,
    required this.duration,
    required this.trashCnt,
    required this.startedAt,
    required this.endedAt,
    required this.ploggingImageList,
  });

  PloggingRecentState copyWith({
    int? ploggingId,
    String? teamName,
    double? distance,
    int? duration,
    int? trashCnt,
    DateTime? startedAt,
    DateTime? endedAt,
    List<PloggingImageState>? ploggingImageList,
  }) {
    return PloggingRecentState(
      ploggingId: ploggingId ?? this.ploggingId,
      teamName: teamName ?? this.teamName,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      trashCnt: trashCnt ?? this.trashCnt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      ploggingImageList: ploggingImageList ?? this.ploggingImageList,
    );
  }

  factory PloggingRecentState.initial() {
    return PloggingRecentState(
      ploggingId: 0,
      teamName: '',
      distance: 0.0,
      duration: 0,
      trashCnt: 0,
      startedAt: DateTime.now(),
      endedAt: DateTime.now(),
      ploggingImageList: [],
    );
  }

  static List<PloggingRecentState> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      if (json is Map<String, dynamic>) {
        return PloggingRecentState.fromJson(json);
      } else {
        throw Exception("Invalid JSON item in list: $json");
      }
    }).toList();
  }


  factory PloggingRecentState.fromJson(Map<String, dynamic> json) {
    return PloggingRecentState(
      ploggingId: json['ploggingId'] as int,
      teamName: json['teamName'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: json['duration'] as int,
      trashCnt: json['trashCnt'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      ploggingImageList:
          (json['ploggingImageList'] as List<dynamic>).map((item) {
        if (item is Map<String, dynamic>) {
          return PloggingImageState.fromJson(item);
        } else {
          throw Exception("Invalid ploggingImageList item: $item");
        }
      }).toList(),
    );
  }
}
