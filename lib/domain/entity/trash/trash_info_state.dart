class TrashInfoState {
  final int plastic;
  final int foodWaste;
  final int glassBottle;
  final int cigaretteButt;
  final int paper;
  final int disposableContainer;
  final int can;
  final int plasticBag;
  final int others;

  const TrashInfoState({
    required this.plastic,
    required this.foodWaste,
    required this.glassBottle,
    required this.cigaretteButt,
    required this.paper,
    required this.disposableContainer,
    required this.can,
    required this.plasticBag,
    required this.others,
  });

  factory TrashInfoState.fromJson(Map<String, dynamic> json) {
    return TrashInfoState(
      plastic: json['plastic'] ?? 0,
      foodWaste: json['foodWaste'] ?? 0,
      glassBottle: json['glassBottle'] ?? 0,
      cigaretteButt: json['cigaretteButt'] ?? 0,
      paper: json['paper'] ?? 0,
      disposableContainer: json['disposableContainer'] ?? 0,
      can: json['can'] ?? 0,
      plasticBag: json['plasticBag'] ?? 0,
      others: json['others'] ?? 0,
    );
  }

  TrashInfoState copyWith({
    int? plastic,
    int? foodWaste,
    int? glassBottle,
    int? cigaretteButt,
    int? paper,
    int? disposableContainer,
    int? can,
    int? plasticBag,
    int? others,
  }) {
    return TrashInfoState(
      plastic: plastic ?? this.plastic,
      foodWaste: foodWaste ?? this.foodWaste,
      glassBottle: glassBottle ?? this.glassBottle,
      cigaretteButt: cigaretteButt ?? this.cigaretteButt,
      paper: paper ?? this.paper,
      disposableContainer: disposableContainer ?? this.disposableContainer,
      can: can ?? this.can,
      plasticBag: plasticBag ?? this.plasticBag,
      others: others ?? this.others,
    );
  }

  factory TrashInfoState.initial() {
    return const TrashInfoState(
      plastic: 0,
      foodWaste: 0,
      glassBottle: 0,
      cigaretteButt: 0,
      paper: 0,
      disposableContainer: 0,
      can: 0,
      plasticBag: 0,
      others: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plastic': plastic,
      'foodWaste': foodWaste,
      'glassBottle': glassBottle,
      'cigaretteButt': cigaretteButt,
      'paper': paper,
      'disposableContainer': disposableContainer,
      'can': can,
      'plasticBag': plasticBag,
      'others': others,
    };
  }

  @override
  String toString() {
    return 'TrashInfoState(plastic: $plastic, foodWaste: $foodWaste, glassBottle: $glassBottle, cigaretteButt: $cigaretteButt, paper: $paper, disposableContainer: $disposableContainer, can: $can, plasticBag: $plasticBag, others: $others)';
  }
}
