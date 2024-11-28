import 'package:toplearth/domain/entity/trash/trash_info_state.dart';

class LegacyInfoState {
  final int totalUserCnt;
  final int totalTrashCnt;
  final TrashInfoState trashInfo;

  const LegacyInfoState({
    required this.totalUserCnt,
    required this.totalTrashCnt,
    required this.trashInfo,
  });

  factory LegacyInfoState.fromJson(Map<String, dynamic> json) {
    return LegacyInfoState(
      totalUserCnt: json['totalUserCnt'] ?? 0,
      totalTrashCnt: json['totalTrashCnt'] ?? 0,
      trashInfo: TrashInfoState.fromJson(json['trashInfo']),
    );
  }

  LegacyInfoState copyWith({
    int? totalUserCnt,
    int? totalTrashCnt,
    TrashInfoState? trashInfo,
  }) {
    return LegacyInfoState(
      totalUserCnt: totalUserCnt ?? this.totalUserCnt,
      totalTrashCnt: totalTrashCnt ?? this.totalTrashCnt,
      trashInfo: trashInfo ?? this.trashInfo,
    );
  }

  factory LegacyInfoState.initial() {
    return LegacyInfoState(
      totalUserCnt: 0,
      totalTrashCnt: 0,
      trashInfo: TrashInfoState.initial(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUserCnt': totalUserCnt,
      'totalTrashCnt': totalTrashCnt,
      'trashInfo': trashInfo.toJson(),
    };
  }

  @override
  String toString() {
    return 'LegacyInfoState(totalUserCnt: $totalUserCnt, totalTrashCnt: $totalTrashCnt, trashInfo: $trashInfo)';
  }
}
