import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class HomeRemoteProvider {
  // 목표 거리 설정
  // /api/v1/users/goal
  Future<ResponseWrapper> setGoalDistance({
    required double goalDistance,
  });
}
