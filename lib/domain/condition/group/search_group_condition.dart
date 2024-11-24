class SearchGroupCondition {
  final String text;

  SearchGroupCondition({
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}