import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/domain/condition/plogging/plogging_report_condition.dart';
import 'package:toplearth/domain/repository/auth/auth_repository.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';

class ReportPloggingUsecase extends BaseUseCase
    implements AsyncConditionUseCase<void, PloggingReportCondition> {
  late final PloggingRepository _ploggingRepository;

  @override
  void onInit() {
    super.onInit();

    _ploggingRepository = Get.find<PloggingRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(PloggingReportCondition condition) async {
    StateWrapper<void> state = await _ploggingRepository.reportPlogging(condition);
    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }
    return StateWrapper<void>(
      success: true,
      message: '플로깅 신고에 성공하였습니다.',
    );
  }
}
