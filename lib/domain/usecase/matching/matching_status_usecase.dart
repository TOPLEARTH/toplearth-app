
import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';

class MatchingStatusUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<void> {
  late final MatchingRepository _matchingRepository;

  @override
  void onInit() {
    super.onInit();
    _matchingRepository = Get.find<MatchingRepository>();
  }

  @override
  Future<StateWrapper<MatchingStatusState>> execute() async {
    StateWrapper<MatchingStatusState> state =
    await _matchingRepository.getMatchingStatus();

    print('MatchingStatusUseCase: ${state.data!.status}');
    return state;
  }
}