import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/store/store_view_model.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreViewModel>(() => StoreViewModel());
  }
}