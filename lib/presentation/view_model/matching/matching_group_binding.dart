import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/matching/matching_by_designated_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_by_random_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_finish_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_recent_plogging_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_status_usecase.dart';
import 'package:toplearth/domain/usecase/matching/matching_vs_finish_usecase.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';

class MatchingGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchingByRandomUseCase>(() => MatchingByRandomUseCase());
    Get.lazyPut<MatchingByDesignatedUseCase>(
        () => MatchingByDesignatedUseCase());
    Get.lazyPut<MatchingFinishUseCase>(() => MatchingFinishUseCase());
    Get.lazyPut<MatchingStatusUseCase>(() => MatchingStatusUseCase());
    Get.lazyPut<MatchingVsFinishUseCase>(() => MatchingVsFinishUseCase());
    Get.lazyPut<MatchingRecentPloggingUseCase>(
        () => MatchingRecentPloggingUseCase());
    Get.lazyPut<MatchingGroupViewModel>(() => MatchingGroupViewModel());
  }
}
