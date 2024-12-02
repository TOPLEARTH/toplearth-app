import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/plogging/plogging_recent.state.dart';
import 'package:toplearth/domain/entity/plogging/recent_matching_info_state.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';
import 'package:get/get.dart';

class MatchingRecentPloggingUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<void> {
  late final MatchingRepository _matchingRepository;

  @override
  void onInit() {
    super.onInit();
    _matchingRepository = Get.find<MatchingRepository>();
  }

  @override
  Future<StateWrapper<RecentMatchingInfoState>> execute() async {
    StateWrapper<RecentMatchingInfoState> state =
        await _matchingRepository.getRecentPlogging();

    return state;
  }
}
