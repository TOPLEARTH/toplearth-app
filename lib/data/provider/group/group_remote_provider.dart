import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class GroupRemoteProvider {
  // 그룹 생성
  // /api/v1/teams
  Future<ResponseWrapper> createGroup({
    required String teamName,
  });

  // 그룹 참여
  // /api/v1/teams/{teamId}/name
  Future<ResponseWrapper> joinGroup({
    required int teamId,
  });

  // 그룹 조회
  // /api/v1/teams
  Future<ResponseWrapper> getGroupDetail();

  // 그룹 검색
  // /api/v1/teams/search?text={}
  Future<ResponseWrapper> searchGroup({
    required String text,
  });

  // 그룹 이름 변경
  // /api/v1/teams/{teamId}/name
  Future<ResponseWrapper> updateGroupName({
    required String teamName,
  });

  // 그룹원 강퇴
  // /api/v1/teams/{teamId}/members/{memberId}
  Future<ResponseWrapper> deleteGroupMember({
    required int teamId,
    required int memberId,
  });

  // 그룹 탈퇴
  // /api/v1/teams/{teamId}
  Future<ResponseWrapper> leaveGroup({
    required int teamId,
  });
}