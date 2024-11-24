import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/group/create_group_usecase.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/matching_group_create/matching_group_create_view_model.dart';

class MatchingGroupCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateGroupUseCase>(
      () => CreateGroupUseCase(),
    );

    Get.lazyPut<MatchingGroupCreateViewModel>(() => MatchingGroupCreateViewModel());
  }
}