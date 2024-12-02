import 'package:toplearth/domain/entity/plogging/plogging_image_state.dart';
import 'package:toplearth/domain/entity/plogging/team_info_state.dart';

class PloggingState {
  final int ploggingId;
  final double distance;
  final int duration; // duration in minutes
  final int trashCnt;
  final String startedAt;
  final String? endedAt;
  final PloggingTeamInfoState ploggingTeamInfo;
  final List<PloggingImageState> ploggingImageList;

  const PloggingState({
    required this.ploggingId,
    required this.distance,
    required this.duration,
    required this.trashCnt,
    required this.startedAt,
    this.endedAt,
    required this.ploggingTeamInfo,
    required this.ploggingImageList,
  });

  factory PloggingState.fromJson(Map<String, dynamic> json) {
    return PloggingState(
      ploggingId: int.tryParse(json['ploggingId']?.toString() ?? '0') ?? 0,
      distance: double.tryParse(json['distance']?.toString() ?? '0') ?? 0.0,
      duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      trashCnt: int.tryParse(json['trashCnt']?.toString() ?? '0') ?? 0,
      startedAt: json['startedAt'] ?? '',
      endedAt: json['endedAt'] ?? '',
      ploggingTeamInfo: PloggingTeamInfoState.fromJson(json['ploggingTeamInfo'] ?? {}),
      ploggingImageList: (json['ploggingImageList'] as List<dynamic>?)
          ?.map((image) => PloggingImageState.fromJson(image))
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'PloggingState(ploggingId: $ploggingId, distance: $distance, duration: $duration, trashCnt: $trashCnt, startedAt: $startedAt, endedAt: $endedAt, ploggingTeamInfo: $ploggingTeamInfo, ploggingImageList: $ploggingImageList)';
  }
}
