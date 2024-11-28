import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/matching/designated_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/random_matching_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';

abstract class MatchingRepository {
  Future<StateWrapper<MatchingStatusState>> requestRandomMatching(
    RandomMatchingCondition condition,
  );

  Future<StateWrapper<void>> requestDesignatedMatching(
    DesignatedMatchingCondition condition,
  );
  Future<StateWrapper<void>> endMatching();
}
