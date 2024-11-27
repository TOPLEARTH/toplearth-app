import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/user/read_user_state_usecase.dart';
import 'package:toplearth/presentation/view_model/group/group_binding.dart';
import 'package:toplearth/presentation/view_model/home/home_binding.dart';
import 'package:toplearth/presentation/view_model/legacy/legacy_binding.dart';
import 'package:toplearth/presentation/view_model/matching/matching_group_binding.dart';
import 'package:toplearth/presentation/view_model/my_page/matching_binding.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_binding.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/view_model/store/store_binding.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootViewModel>(() => RootViewModel());
    Get.lazyPut<ReadBootStrapUseCase>(
          () => ReadBootStrapUseCase(),
    );
    PloggingBinding().dependencies();
    MyPageBinding().dependencies();
    MatchingGroupBinding().dependencies();
    HomeBinding().dependencies();
    StoreBinding().dependencies();
    GroupBinding().dependencies();
    LegacyBinding().dependencies();
  }
}
