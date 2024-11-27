import 'package:toplearth/domain/condition/plogging/finish_plogging_condition.dart';
import 'package:toplearth/domain/condition/plogging/plogging_labeling_condition.dart';
import 'package:toplearth/domain/condition/plogging/start_individual_plogging_condition.dart';
import 'package:toplearth/domain/condition/plogging/upload_plogging_image_condition.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_list_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_upload_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_start_individual_state.dart';

import '../../../core/wrapper/state_wrapper.dart';

abstract class PloggingRepository {
  Future<StateWrapper<PloggingImageUploadState>> uploadPloggingImage(
      UploadPloggingImageCondition condition);

  Future<StateWrapper<PloggingStartIndividualState>> startIndividualPlogging(
      StartIndividualPloggingCondition condition);

  Future<StateWrapper<PloggingImageListState>> finishPlogging(FinishPloggingCondition condition);

  Future<StateWrapper<void>> labelingPloggingImages(PloggingLabelingCondition condition);
}
