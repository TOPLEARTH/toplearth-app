import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/finish_plogging_condition.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_list_state.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';

class FinishPloggingUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, FinishPloggingCondition> {
  late final PloggingRepository _ploggingRepository;

  @override
  void onInit() {
    super.onInit();
    _ploggingRepository = Get.find<PloggingRepository>();
  }

  @override
  Future<StateWrapper<PloggingImageListState>> execute(
      FinishPloggingCondition condition) async {
    StateWrapper<PloggingImageListState> state =
        await _ploggingRepository.finishPlogging(condition);

    return state;
  }
}
