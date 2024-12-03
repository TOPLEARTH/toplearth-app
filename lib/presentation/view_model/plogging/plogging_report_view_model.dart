import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/plogging_report_condition.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';


class PloggingReportViewModel extends GetxController {
  late final PloggingRepository _ploggingRepository;

  @override
  void onInit() {
    super.onInit();
    _ploggingRepository = Get.find<PloggingRepository>();
  }

  Future<ResultWrapper> reportPlogging(int ploggingId) async {
    StateWrapper<void> state = await _ploggingRepository
        .reportPlogging(PloggingReportCondition(ploggingId: ploggingId));

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }
}
