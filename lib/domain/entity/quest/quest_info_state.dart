import 'package:toplearth/domain/entity/quest/quest_state.dart';

class QuestInfoState {
  final Map<String, List<QuestState>> dailyQuest;

  QuestInfoState({required this.dailyQuest});

  factory QuestInfoState.fromJson(Map<String, dynamic> json) {
    final dailyQuestData = json['dailyQuest'] as Map<String, dynamic>? ?? {};

    // Parse each date's list of quests into a Map<String, List<QuestState>>
    final parsedDailyQuests = dailyQuestData.map((date, quests) {
      final questList = (quests as List<dynamic>)
          .map((quest) => QuestState.fromJson(quest))
          .toList();
      return MapEntry(date, questList);
    });

    return QuestInfoState(dailyQuest: parsedDailyQuests);
  }

  /// Static initial value
  static QuestInfoState get initial => QuestInfoState(dailyQuest: {});

  @override
  String toString() {
    return 'QuestInfoState(dailyQuest: $dailyQuest)';
  }
}
