import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/group/create_group_condition.dart';
import 'package:toplearth/domain/entity/group/group_create_state.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';

class CreateGroupUseCase extends BaseUseCase
    implements AsyncConditionUseCase<GroupCreateState, CreateGroupCondition> {
  late final GroupRepository _groupRepository;

  @override
  void onInit() {
    super.onInit();
    _groupRepository = Get.find<GroupRepository>();
  }

  @override
  Future<StateWrapper<GroupCreateState>> execute(
      CreateGroupCondition condition) async {
    StateWrapper<GroupCreateState> state =
        await _groupRepository.createGroup(condition);

    return state;
  }
}
