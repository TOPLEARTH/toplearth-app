import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/home/set_goal_distance_usecase.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(() => HomeViewModel());
    Get.lazyPut<SetGoalDistanceUseCase>(() => SetGoalDistanceUseCase());
  }
}
