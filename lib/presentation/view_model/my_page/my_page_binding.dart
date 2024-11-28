import 'package:get/get.dart';
import 'package:toplearth/presentation/view_model/my_page/my_page_view_model.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPageViewModel>(() => MyPageViewModel());
  }
}
