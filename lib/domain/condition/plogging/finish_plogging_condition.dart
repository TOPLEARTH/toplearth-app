import 'dart:io';
import 'package:toplearth/domain/entity/plogging/plogging_finish_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_state.dart';

class FinishPloggingCondition {
  final int ploggingId;
  final PloggingFinishState ploggingData;

  FinishPloggingCondition({
    required this.ploggingId,
    required this.ploggingData,
  });

  factory FinishPloggingCondition.initial({
    required int ploggingId,
    required PloggingState ploggingState,
    required File ploggingImage,
  }) {
    return FinishPloggingCondition(
      ploggingId: ploggingId,
      ploggingData: PloggingFinishState(
        distance: ploggingState.distance,
        duration: ploggingState.duration,
        pickUpCnt: ploggingState.trashCnt,
        burnedCalories: 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ploggingId': ploggingId,
      'distance': ploggingData.distance,
      'duration': ploggingData.duration,
      'pickUpCnt': ploggingData.pickUpCnt,
      'burnedCalories': ploggingData.burnedCalories,
    };
  }
}
