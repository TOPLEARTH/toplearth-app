import 'package:get/get.dart';
import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/data/provider/matching/matching_remote_provider.dart';

class MatchingRemoteProviderImpl extends BaseConnect
    implements MatchingRemoteProvider {
  // 랜덤 매칭 요청
  @override
  Future<ResponseWrapper> requestRandomMatching({
    required int teamId,
  }) async {
    Response response = await post(
      "/api/v1/matching/random",
      {"teamId": teamId},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 지정 매칭 요청
  @override
  Future<ResponseWrapper> requestDesignatedMatching({
    required int teamId,
    required int opponentTeamId,
  }) async {
    Response response = await post(
      "/api/v1/matching/$opponentTeamId",
      {"teamId": teamId},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 매칭 종료
  @override
  Future<ResponseWrapper> endMatching() async {
    Response response = await patch(
      "/api/v1/matching/end",
      {},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }
}
