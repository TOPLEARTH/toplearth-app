class QuestState {
  final int questId;
  final String title;
  final int target;
  final int questCredit;
  final int currentProgress;
  final bool isCompleted;
  final int progressRate;
  final String createdAt;
  final String? completedAt;

  QuestState({
    required this.questId,
    required this.title,
    required this.target,
    required this.questCredit,
    required this.currentProgress,
    required this.isCompleted,
    required this.progressRate,
    required this.createdAt,
    this.completedAt,
  });

  factory QuestState.fromJson(Map<String, dynamic> json) {
    return QuestState(
      questId: int.tryParse(json['questId']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      target: int.tryParse(json['target']?.toString() ?? '0') ?? 0,
      questCredit: int.tryParse(json['questCredit']?.toString() ?? '0') ?? 0,
      currentProgress: int.tryParse(json['currentProgress']?.toString() ?? '0') ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      progressRate: int.tryParse(json['progressRate']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] ?? '',
      completedAt: json['completedAt'], // nullable, 그대로 사용
    );
  }

  @override
  String toString() {
    return 'QuestState(questId: $questId, title: $title, target: $target, questCredit: $questCredit, currentProgress: $currentProgress, isCompleted: $isCompleted, progressRate: $progressRate, createdAt: $createdAt, completedAt: $completedAt)';
  }
}
