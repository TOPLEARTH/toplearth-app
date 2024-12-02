import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/matching/designated_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/end_vs_matching_condition.dart';
import 'package:toplearth/domain/condition/matching/random_matching_condition.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_recent.state.dart';
import 'package:toplearth/domain/entity/plogging/recent_matching_info_state.dart';

abstract class MatchingRepository {
  Future<StateWrapper<MatchingStatusState>> requestRandomMatching(
    RandomMatchingCondition condition,
  );

  Future<StateWrapper<void>> requestDesignatedMatching(
    DesignatedMatchingCondition condition,
  );
  Future<StateWrapper<void>> endMatching();

  Future<StateWrapper<MatchingStatusState>> getMatchingStatus();

  Future<StateWrapper<MatchingStatusState>> endVsMatching(EndVsMatchingCondition condition);

  Future<StateWrapper<RecentMatchingInfoState>> getRecentPlogging();
}
