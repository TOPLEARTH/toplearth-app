import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/group/leave_group_condition.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';

class LeaveGroupUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, LeaveGroupCondition> {
  late final GroupRepository _groupRepository;

  @override
  void onInit() {
    super.onInit();
    _groupRepository = Get.find<GroupRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(LeaveGroupCondition condition) async {
    StateWrapper<void> state = await _groupRepository.leaveGroup(condition);
    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }

    return StateWrapper<void>(
      success: true,
      message: '그룹 탈퇴에 성공하였습니다.',
    );
  }
}