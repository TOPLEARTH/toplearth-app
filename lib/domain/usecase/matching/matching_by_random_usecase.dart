import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/matching/random_matching_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';

class MatchingByRandomUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, RandomMatchingCondition> {
  late final MatchingRepository _matchingRepository;

  @override
  void onInit() {
    super.onInit();
    _matchingRepository = Get.find<MatchingRepository>();
  }

  @override
  Future<StateWrapper<MatchingStatusState>> execute(
      RandomMatchingCondition condition) async {
    StateWrapper<MatchingStatusState> state =
        await _matchingRepository.requestRandomMatching(condition);
    return state;
  }
}
