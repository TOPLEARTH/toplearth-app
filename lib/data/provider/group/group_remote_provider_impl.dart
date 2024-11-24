import 'package:get/get.dart';
import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/data/provider/group/group_remote_provider.dart';

class GroupRemoteProviderImpl extends BaseConnect implements GroupRemoteProvider {
  // 그룹 생성
  @override
  Future<ResponseWrapper> createGroup({
    required String teamName,
  }) async {
    Response response = await post(
      "/api/v1/teams",
      {"teamName": teamName},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 그룹 참여
  @override
  Future<ResponseWrapper> joinGroup({
    required int teamId,
  }) async {
    Response response = await post(
      "/api/v1/teams/$teamId/join",
      {},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 그룹 조회
  @override
  Future<ResponseWrapper> getGroupDetail() async {
    Response response = await get(
      "/api/v1/teams",
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 그룹 검색
  @override
  Future<ResponseWrapper> searchGroup({
    required String text,
  }) async {
    Response response = await get(
      "/api/v1/teams/search",
      query: {"text": text},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 그룹 이름 변경
  @override
  Future<ResponseWrapper> updateGroupName({
    required String teamName,
  }) async {
    Response response = await patch(
      "/api/v1/teams/name",
      {"teamName": teamName},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 그룹원 강퇴
  @override
  Future<ResponseWrapper> deleteGroupMember({
    required int memberId,
    required int teamId,
  }) async {
    Response response = await delete(
      "/api/v1/teams/$teamId/members/$memberId",
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 그룹 탈퇴
  @override
  Future<ResponseWrapper> leaveGroup({
    required int teamId,
  }) async {
    Response response = await delete(
      "/api/v1/teams/$teamId",
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }
}
