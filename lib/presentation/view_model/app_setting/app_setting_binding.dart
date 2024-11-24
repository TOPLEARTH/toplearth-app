import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/app_setting/app_setting_view_model.dart';

class AppSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppSettingViewModel>(() => AppSettingViewModel());
  }
}
