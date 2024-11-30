import 'package:get/get.dart';
import 'package:toplearth/app/utility/log_util.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/home/set_goal_distance_condition.dart';
import 'package:toplearth/domain/repository/home/home_repository.dart';

class SetGoalDistanceUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, SetGoalDistanceCondition> {
  late final HomeRepository _homeRepository;

  @override
  void onInit() {
    super.onInit();
    _homeRepository = Get.find<HomeRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(SetGoalDistanceCondition condition) async {
    StateWrapper<void> state = await _homeRepository.setGoalDistance(condition);
    if (!state.success) {
      LogUtil.debug('목표 거리 설정 중 오류 발생: ${state.message}');
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }

    return StateWrapper<void>(
      success: true,
      message: '목표 거리가 성공적으로 설정되었습니다.',
    );
  }
}
