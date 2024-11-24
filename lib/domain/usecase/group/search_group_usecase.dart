import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/group/search_group_condition.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';

class SearchGroupUseCase extends BaseUseCase
    implements AsyncConditionUseCase<List<GroupBriefState>, SearchGroupCondition> {
  late final GroupRepository _groupRepository;

  @override
  void onInit() {
    super.onInit();
    _groupRepository = Get.find<GroupRepository>();
  }

  @override
  Future<StateWrapper<List<GroupBriefState>>> execute(
      SearchGroupCondition condition) async {
    StateWrapper<List<GroupBriefState>> state =
    await _groupRepository.searchGroup(condition);

    print('검색 결과: ${state.data}');

    return state;
  }
}
