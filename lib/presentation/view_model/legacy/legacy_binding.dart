import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/legacy/legacy_view_model.dart';

class LegacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegacyViewModel>(() => LegacyViewModel());
  }
}
