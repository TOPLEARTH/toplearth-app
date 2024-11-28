import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';

class MatchingFinishUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<void> {
  late final MatchingRepository _matchingRepository;

  @override
  void onInit() {
    super.onInit();
     _matchingRepository = Get.find<MatchingRepository>();
  }

  @override
  Future<StateWrapper<void>> execute() async {
    StateWrapper<void> state = await _matchingRepository.endMatching();
    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }

    return StateWrapper<void>(
      success: true,
      message: '매칭종료에 성공하였습니다.',
    );
  }
}