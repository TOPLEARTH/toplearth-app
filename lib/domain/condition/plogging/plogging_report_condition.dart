
class PloggingReportCondition{
  final int ploggingId;
  PloggingReportCondition({required this.ploggingId});

  factory PloggingReportCondition.initial({required int ploggingId}){
    return PloggingReportCondition(ploggingId: ploggingId);
  }

  Map<String, dynamic> toJson(){
    return {
      'ploggingId': ploggingId,
    };
  }


}