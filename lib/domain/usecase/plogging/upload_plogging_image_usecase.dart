import 'dart:io';
import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/plogging/upload_plogging_image_condition.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_upload_state.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';

class UploadPloggingImageUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, UploadPloggingImageCondition> {
  late final PloggingRepository _ploggingRepository;

  @override
  void onInit() {
    super.onInit();
    _ploggingRepository = Get.find<PloggingRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(
      UploadPloggingImageCondition condition) async {
    StateWrapper<void> state =
        await _ploggingRepository.uploadPloggingImage(condition);

    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }
    return StateWrapper(
      success: true,
      message: '플로깅 이미지 업로드에 성공하였습니다.',
    );
  }
}
