class PloggingNoLabelState {
  final int ploggingImageId;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String createdAt;

  const PloggingNoLabelState({
    required this.ploggingImageId,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  PloggingNoLabelState copyWith({
    int? ploggingImageId,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? createdAt,
  }) {
    return PloggingNoLabelState(
      ploggingImageId: ploggingImageId ?? this.ploggingImageId,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PloggingNoLabelState.initial() {
    return PloggingNoLabelState(
      ploggingImageId: 0,
      imageUrl: '',
      latitude: 0.0,
      longitude: 0.0,
      createdAt: '',
    );
  }

  factory PloggingNoLabelState.fromJson(Map<String, dynamic> json) {
    return PloggingNoLabelState(
      ploggingImageId: json['ploggingImageId'] as int,
      imageUrl: json['imageUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ploggingImageId': ploggingImageId,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
    };
  }
}
