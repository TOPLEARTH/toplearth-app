import 'package:toplearth/domain/entity/group/label_state.dart';
import 'package:toplearth/domain/entity/group/member_state.dart';

class MonthlyGroupState {
  final List<MemberState> members;
  final List<LabelState> labels;

  MonthlyGroupState({
    required this.members,
    required this.labels,
  });

  factory MonthlyGroupState.fromJson(Map<String, dynamic> json) {
    return MonthlyGroupState(
      // Parse distances into MemberState list
      members: (json['distances'] as List<dynamic>?)
              ?.map((member) => MemberState.fromJson(member))
              .toList() ??
          [],

      // Parse labels into LabelState list
      labels: (json['labels'] as List<dynamic>?)
              ?.map((label) => LabelState.fromJson(label))
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'MonthlyGroupState(members: $members, labels: $labels)';
  }
}
