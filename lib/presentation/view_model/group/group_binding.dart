import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/group/group_view_model.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupViewModel>(() => GroupViewModel());
  }
}