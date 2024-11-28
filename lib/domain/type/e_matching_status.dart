enum EMatchingStatus implements Comparable<EMatchingStatus> {
  NOTJOINED,
  DEFAULT,
  WAITING,
  MATCHED,
  FINISHED;

  const EMatchingStatus();

  @override
  int compareTo(EMatchingStatus other) => index.compareTo(other.index);

  @override
  String toString() => name;
}
