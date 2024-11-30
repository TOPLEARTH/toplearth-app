import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/home/set_goal_distance_condition.dart';

abstract class HomeRepository {
  Future<StateWrapper<void>> setGoalDistance(
      SetGoalDistanceCondition condition);
}
