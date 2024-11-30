// user_repository_impl.dart
import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/home/home_provider.dart';
import 'package:toplearth/domain/condition/home/set_goal_distance_condition.dart';
import 'package:toplearth/domain/repository/home/home_repository.dart';

class HomeRepositoryImpl extends GetxService implements HomeRepository {
  late final HomeRemoteProvider _homeProvider;

  @override
  void onInit() {
    super.onInit();
    _homeProvider = Get.find<HomeRemoteProvider>();
  }

  @override
  Future<StateWrapper<SetGoalDistanceCondition>> setGoalDistance(
      SetGoalDistanceCondition condition) async {
    ResponseWrapper response = await _homeProvider.setGoalDistance(
      goalDistance: condition.goalDistance,
    );

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    return StateWrapper.fromResponse(response);
  }
}
