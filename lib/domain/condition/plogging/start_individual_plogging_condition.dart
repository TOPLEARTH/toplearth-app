class StartIndividualPloggingCondition {
  final int regionId;

  StartIndividualPloggingCondition({
    required this.regionId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regionId'] = regionId;
    return data;
  }
}
