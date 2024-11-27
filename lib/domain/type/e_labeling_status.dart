enum ELabelingStatus implements Comparable<ELabelingStatus> {
  plastic('PLASTIC'),
  foodWaste('FOOD_WASTE'),
  glass('GLASS'),
  cigarette('CIGARETTE'),
  paper('PAPER'),
  general('GENERAL'),
  can('CAN'),
  plasticBag('PLASTIC_BAG'),
  others('OTHERS');

  final String serverName;

  const ELabelingStatus(this.serverName);

  @override
  int compareTo(ELabelingStatus other) => index.compareTo(other.index);

  @override
  String toString() => serverName;
}
