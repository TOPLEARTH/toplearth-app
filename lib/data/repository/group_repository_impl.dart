import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/group/group_remote_provider.dart';
import 'package:toplearth/domain/condition/group/create_group_condition.dart';
import 'package:toplearth/domain/condition/group/delete_group_member_condition.dart';
import 'package:toplearth/domain/condition/group/join_group_condition.dart';
import 'package:toplearth/domain/condition/group/leave_group_condition.dart';
import 'package:toplearth/domain/condition/group/search_group_condition.dart';
import 'package:toplearth/domain/condition/group/update_group_name_condition.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/domain/entity/group/group_create_state.dart';
import 'package:toplearth/domain/entity/group/group_detail_state.dart';
import 'package:toplearth/domain/entity/group/group_name_state.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';

class GroupRepositoryImpl extends GetxService implements GroupRepository {
  late final GroupRemoteProvider _groupRemoteProvider;

  @override
  void onInit() {
    super.onInit();
    _groupRemoteProvider = Get.find<GroupRemoteProvider>();
  }

  // 그룹 생성
  @override
  Future<StateWrapper<GroupCreateState>> createGroup(CreateGroupCondition condition) async {
    ResponseWrapper response = await _groupRemoteProvider.createGroup(
      teamName: condition.teamName,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  // 그룹 참여
  @override
  Future<StateWrapper<void>> joinGroup(JoinGroupCondition condition) async {
    ResponseWrapper response = await _groupRemoteProvider.joinGroup(
      teamId: condition.teamId,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  // 그룹 조회
  @override
  Future<StateWrapper<GroupDetailState>> getGroupDetail() async {
    ResponseWrapper response = await _groupRemoteProvider.getGroupDetail();

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    Map<String, dynamic> groupDetailInfo = response.data!;
    GroupDetailState state = GroupDetailState.fromJson(groupDetailInfo);

    return StateWrapper.fromResponseAndState(response, state);
  }

  // 그룹 검색
  @override
  Future<StateWrapper<List<GroupBriefState>>> searchGroup(
      SearchGroupCondition condition) async {
    ResponseWrapper response = await _groupRemoteProvider.searchGroup(
      text: condition.text,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    // Extract the "teams" array from "data"
    List<dynamic> groupList = response.data?['teams'] ?? [];
    List<GroupBriefState> groupBriefStateList = groupList
        .map((group) => GroupBriefState.fromJson(group as Map<String, dynamic>))
        .toList();

    return StateWrapper.fromResponseAndState(response, groupBriefStateList);
  }


  // 그룹 이름 변경
  @override
  Future<StateWrapper<GroupNameState>> updateGroupName(
      UpdateGroupNameCondition condition) async {
    ResponseWrapper response = await _groupRemoteProvider.updateGroupName(
      teamName: condition.teamName,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  // 그룹원 강퇴
  @override
  Future<StateWrapper<void>> deleteGroupMember(
      DeleteGroupMemberCondition condition) async {
    ResponseWrapper response = await _groupRemoteProvider.deleteGroupMember(
      teamId: condition.teamId,
      memberId: condition.memberId,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  // 그룹 탈퇴
  @override
  Future<StateWrapper<void>> leaveGroup(LeaveGroupCondition condition) async {
    ResponseWrapper response = await _groupRemoteProvider.leaveGroup(
      teamId: condition.teamId,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }
}
