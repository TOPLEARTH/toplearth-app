import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/my_page/matching_view_model.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPageViewModel>(() => MyPageViewModel());
  }
}