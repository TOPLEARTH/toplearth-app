import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/group/create_group_condition.dart';
import 'package:toplearth/domain/condition/group/delete_group_member_condition.dart';
import 'package:toplearth/domain/condition/group/join_group_condition.dart';
import 'package:toplearth/domain/condition/group/leave_group_condition.dart';
import 'package:toplearth/domain/condition/group/search_group_condition.dart';
import 'package:toplearth/domain/condition/group/update_group_name_condition.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/domain/entity/group/group_create_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/entity/group/group_name_state.dart';

abstract class GroupRepository {
  Future<StateWrapper<GroupCreateState>> createGroup(
      CreateGroupCondition condition,
      );

  Future<StateWrapper<void>> joinGroup(
      JoinGroupCondition condition,
      );

  Future<StateWrapper<TeamInfoState>> getGroupDetail();

  Future<StateWrapper<List<GroupBriefState>>> searchGroup(
      SearchGroupCondition condition,
      );

  Future<StateWrapper<GroupNameState>> updateGroupName(
      UpdateGroupNameCondition condition,
      );

  Future<StateWrapper<void>> deleteGroupMember(
      DeleteGroupMemberCondition condition,
      );

  Future<StateWrapper<void>> leaveGroup(
      LeaveGroupCondition condition,
      );
}
