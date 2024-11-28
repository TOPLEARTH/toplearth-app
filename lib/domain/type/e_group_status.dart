enum EGroupStatus implements Comparable<EGroupStatus> {
  notJoined,
  joined,
  matching,
  matched,
  plogging,
  ;

  const EGroupStatus();

  @override
  int compareTo(EGroupStatus other) => index.compareTo(other.index);

  @override
  String toString() => name;
}
