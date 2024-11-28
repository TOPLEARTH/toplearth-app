import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class MatchingRemoteProvider {
  // 랜덤 매칭 요청
  // /api/v1/matching/random
  Future<ResponseWrapper> requestRandomMatching({
    required int teamId,
  });

  // 지정 매칭 요청
  // /api/v1/matching/${opponentTeamId}
  Future<ResponseWrapper> requestDesignatedMatching({
    required int teamId,
    required int opponentTeamId,
  });

  // 매칭 종료
  // /api/v1/matching/end
  Future<ResponseWrapper> endMatching();
}
