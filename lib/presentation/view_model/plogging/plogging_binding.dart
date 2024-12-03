import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/plogging/finish_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/labeling_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/start_individual_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/plogging/upload_plogging_image_usecase.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_report_view_model.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class PloggingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadPloggingImageUseCase>(() => UploadPloggingImageUseCase());
    Get.lazyPut<FinishPloggingUseCase>(() => FinishPloggingUseCase());
    Get.lazyPut<LabelingPloggingUseCase>(() => LabelingPloggingUseCase());
    Get.lazyPut<StartIndividualPloggingUseCase>(() => StartIndividualPloggingUseCase());
    Get.lazyPut<PloggingViewModel>(() => PloggingViewModel());
    Get.lazyPut<PloggingReportViewModel>(() => PloggingReportViewModel());
  }
}
