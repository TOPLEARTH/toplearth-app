import 'package:get/get.dart';
import 'package:toplearth/test_code/plogging_view_model.dart';

class PloggingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PloggingViewModel>(() => PloggingViewModel());
  }
}
