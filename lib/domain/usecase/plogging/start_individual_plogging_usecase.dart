import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/start_individual_plogging_condition.dart';
import 'package:toplearth/domain/entity/plogging/plogging_start_individual_state.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';

class StartIndividualPloggingUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, StartIndividualPloggingCondition> {
  late final PloggingRepository _ploggingRepository;
  @override
  void onInit() {
    super.onInit();
    _ploggingRepository = Get.find<PloggingRepository>();
  }

  @override
  Future<StateWrapper<PloggingStartIndividualState>> execute(
      StartIndividualPloggingCondition condition) async {
    StateWrapper<PloggingStartIndividualState> state =
        await _ploggingRepository.startIndividualPlogging(condition);

    return state;
  }
}
