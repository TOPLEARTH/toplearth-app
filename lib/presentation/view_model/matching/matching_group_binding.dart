import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';

class MatchingGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchingGroupViewModel>(() => MatchingGroupViewModel());
  }
}