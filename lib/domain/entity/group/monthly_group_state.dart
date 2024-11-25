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
      members: (json['monthlyData']?['2024-12']?['distances'] as List<dynamic>?)
              ?.map((member) => MemberState.fromJson(member))
              .toList() ??
          [],
      labels: (json['monthlyData']?['2024-12']?['labels'] as List<dynamic>?)
              ?.map((label) => LabelState.fromJson(label))
              .toList() ??
          [],
    );
  }
}
