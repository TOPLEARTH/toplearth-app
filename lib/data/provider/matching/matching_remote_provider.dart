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

  // 매칭 상태 조회
  // /api/v1/matching/status
  Future<ResponseWrapper> getMatchingStatus();

  // 대결 종료
  // /api/v1/matching/${matchingId}/end
  Future<ResponseWrapper> endVsMatching({
    required int matchingId,
    required int competitionScore,
    required int totalPickUpCnt,
    required bool winFlag,
  });

  // 최근 플로깅 조회
  // /api/v1/matching/plogging
  Future<ResponseWrapper> getRecentPlogging();
}
