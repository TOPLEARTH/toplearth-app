import 'package:toplearth/domain/entity/quest/quest_state.dart';

class QuestInfoState {
  final List<QuestState> dailyQuest;

  QuestInfoState({
    required this.dailyQuest,
  });

  QuestInfoState copyWith({
    List<QuestState>? dailyQuest,
  }) {
    return QuestInfoState(
      dailyQuest: dailyQuest ?? this.dailyQuest,
    );
  }

  factory QuestInfoState.initial() {
    return QuestInfoState(
      dailyQuest: [],
    );
  }

  factory QuestInfoState.fromJson(Map<String, dynamic> json) {
    return QuestInfoState(
      dailyQuest: (json['dailyQuest'] as List<dynamic>?)
          ?.map((quest) => QuestState.fromJson(quest))
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'QuestInfoState(dailyQuest: $dailyQuest)';
  }
}
