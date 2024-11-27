import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/plogging_labeling_condition.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';

class LabelingPloggingUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, PloggingLabelingCondition> {
  late final PloggingRepository _ploggingRepository;

  @override
  void onInit() {
    super.onInit();
    _ploggingRepository = Get.find<PloggingRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(
      PloggingLabelingCondition condition) async {
    StateWrapper<void> state =
        await _ploggingRepository.labelingPloggingImages(condition);

    return state;
  }
}
