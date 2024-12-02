// 대결 종료 조건
class EndVsMatchingCondition{
  final int matchingId;
  final int competitionScore;
  final int totalPickUpCnt;
  final bool winFlag;

  EndVsMatchingCondition({
    required this.matchingId,
    required this.competitionScore,
    required this.totalPickUpCnt,
    required this.winFlag,
  });
}