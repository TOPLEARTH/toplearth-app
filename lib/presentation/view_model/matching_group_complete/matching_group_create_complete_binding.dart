import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/matching_group_complete/matching_group_create_complete_view_model.dart';

class MatchingGroupCreateCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchingGroupCreateCompleteViewModel>(() => MatchingGroupCreateCompleteViewModel());
  }
}