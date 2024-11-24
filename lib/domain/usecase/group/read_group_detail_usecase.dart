import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/group/group_detail_state.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';

class ReadGroupDetailUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<GroupDetailState> {
  late final GroupRepository _groupRepository;

  @override
  void onInit() {
    super.onInit();
    _groupRepository = Get.find<GroupRepository>();
  }

  @override
  Future<StateWrapper<GroupDetailState>> execute() async {
    StateWrapper<GroupDetailState> state = await _groupRepository.getGroupDetail();

    return state;
  }
}
