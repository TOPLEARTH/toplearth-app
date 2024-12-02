enum EMatchingStatus implements Comparable<EMatchingStatus> {
  NOT_JOINED,
  DEFAULT,
  WAITING,
  PLOGGING,
  MATCHED,
  FINISHED;

  const EMatchingStatus();

  @override
  int compareTo(EMatchingStatus other) => index.compareTo(other.index);

  @override
  String toString() => name;

  /// JSON 값에서 EMatchingStatus로 변환
  static EMatchingStatus fromJson(String jsonValue) {
    switch (jsonValue) {
      case 'NOT_JOINED':
        return EMatchingStatus.NOT_JOINED;
      case 'DEFAULT':
        return EMatchingStatus.DEFAULT;
      case 'WAITING':
        return EMatchingStatus.WAITING;
      case 'PLOGGING':
        return EMatchingStatus.PLOGGING;
      case 'MATCHED':
        return EMatchingStatus.MATCHED;
      case 'FINISHED':
        return EMatchingStatus.FINISHED;
      default:
        print("Unknown status received: $jsonValue");
        return EMatchingStatus.DEFAULT; // 기본 상태 반환
    }
  }
}
