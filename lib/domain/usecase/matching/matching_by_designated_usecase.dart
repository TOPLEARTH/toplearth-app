import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/matching/designated_matching_condition.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';

class MatchingByDesignatedUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, DesignatedMatchingCondition> {
  late final MatchingRepository _matchingRepository;

  @override
  void onInit() {
    super.onInit();
    _matchingRepository = Get.find<MatchingRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(
      DesignatedMatchingCondition condition) async {
    StateWrapper<void> state =
        await _matchingRepository.requestDesignatedMatching(condition);
    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }

    return StateWrapper<void>(
      success: true,
      message: '지정 매칭 요청에 성공하셨습니다.',
    );
  }
}
