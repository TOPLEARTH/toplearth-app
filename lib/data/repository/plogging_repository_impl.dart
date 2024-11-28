import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/plogging/plogging_remote_provider.dart';
import 'package:toplearth/domain/condition/plogging/finish_plogging_condition.dart';
import 'package:toplearth/domain/condition/plogging/plogging_labeling_condition.dart';
import 'package:toplearth/domain/condition/plogging/start_individual_plogging_condition.dart';
import 'package:toplearth/domain/condition/plogging/upload_plogging_image_condition.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_list_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_upload_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_start_individual_state.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';

class PloggingRepositoryImpl extends GetxService implements PloggingRepository {
  late final PloggingRemoteProvider _ploggingRemoteProvider;

  @override
  void onInit() {
    super.onInit();
    _ploggingRemoteProvider = Get.find<PloggingRemoteProvider>();
  }

  @override
  Future<StateWrapper<PloggingImageUploadState>> uploadPloggingImage(
      UploadPloggingImageCondition condition) async {
    try {
      final response = await _ploggingRemoteProvider.uploadPloggingImage(
        ploggingImage: condition.ploddingImage,
        ploggingId: condition.ploggingId,
        latitude: condition.latitude,
        longitude: condition.longitude,
      );

      if (!response.success) {
        return StateWrapper(
          success: false,
          message: response.message,
        );
      }

      return StateWrapper(
        success: true,
        message: response.message,
      );
    } catch (e) {
      return StateWrapper(
        success: false,
        message: '이미지 업로드 중 오류 발생: $e',
      );
    }
  }

  @override
  Future<StateWrapper<PloggingStartIndividualState>> startIndividualPlogging(
      StartIndividualPloggingCondition condition) async {
    ResponseWrapper response =
        await _ploggingRemoteProvider.startIndividualPlogging(
      regionId: condition.regionId,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    PloggingStartIndividualState state =
        PloggingStartIndividualState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }

  Future<StateWrapper<void>> labelingPloggingImages(
      PloggingLabelingCondition condition) async {
    ResponseWrapper response =
        await _ploggingRemoteProvider.labelingPloggingImages(
      ploggingId: condition.ploggingId,
      ploggingImage: condition.ploggingImage,
      ploggingImageIds: condition.ploggingImageIds,
      labels: condition.labels,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }

  @override
  Future<StateWrapper<PloggingImageListState>> finishPlogging(
      FinishPloggingCondition condition) async {
    ResponseWrapper response = await _ploggingRemoteProvider.finishPlogging(
      ploggingId: condition.ploggingId,
      distance: condition.ploggingData.distance,
      duration: condition.ploggingData.duration,
      pickUpCnt: condition.ploggingData.pickUpCnt,
      burnedCalories: condition.ploggingData.burnedCalories,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    PloggingImageListState state = PloggingImageListState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }
}
