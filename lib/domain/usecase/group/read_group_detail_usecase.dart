import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';

class ReadGroupDetailUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<TeamInfoState> {
  late final GroupRepository _groupRepository;

  @override
  void onInit() {
    super.onInit();
    _groupRepository = Get.find<GroupRepository>();
  }

  @override
  Future<StateWrapper<TeamInfoState>> execute() async {
    StateWrapper<TeamInfoState> state = await _groupRepository.getGroupDetail();

    return state;
  }
}
