class QuestState {
  final double? targetKmName;
  final int? targetPickNumber;
  final int? targetLabelNumber;
  final double? myKmNumber;
  final int? myPickNumber;
  final int? myLabelNumber;
  final String createdAt;

  QuestState({
    this.targetKmName,
    this.targetPickNumber,
    this.targetLabelNumber,
    this.myKmNumber,
    this.myPickNumber,
    this.myLabelNumber,
    required this.createdAt,
  });

  factory QuestState.fromJson(Map<String, dynamic> json) {
    return QuestState(
      targetKmName: (json['targetKmName'] != null)
          ? double.tryParse(json['targetKmName'].toString())
          : null,
      targetPickNumber: json['targetPickNumber'] as int?,
      targetLabelNumber: json['targetLabelNumber'] as int?,
      myKmNumber: (json['myKmNumber'] != null)
          ? double.tryParse(json['myKmNumber'].toString())
          : null,
      myPickNumber: json['myPickNumber'] as int?,
      myLabelNumber: json['myLabelNumber'] as int?,
      createdAt: json['createdAt'] ?? '',
    );
  }

  /// Static initial value
  static QuestState get initial => QuestState(
        targetKmName: null,
        targetPickNumber: null,
        targetLabelNumber: null,
        myKmNumber: null,
        myPickNumber: null,
        myLabelNumber: null,
        createdAt: '', // Default empty string for createdAt
      );

  @override
  String toString() {
    return 'QuestState(targetKmName: $targetKmName, targetPickNumber: $targetPickNumber, targetLabelNumber: $targetLabelNumber, myKmNumber: $myKmNumber, myPickNumber: $myPickNumber, myLabelNumber: $myLabelNumber, createdAt: $createdAt)';
  }
}
