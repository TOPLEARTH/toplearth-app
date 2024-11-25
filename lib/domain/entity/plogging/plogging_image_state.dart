class PloggingImageState {
  final int ploggingImageId;
  final String imageUrl;
  final String createdAt;
  final double latitude;
  final double longitude;
  final String label;

  const PloggingImageState({
    required this.ploggingImageId,
    required this.imageUrl,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  factory PloggingImageState.fromJson(Map<String, dynamic> json) {
    return PloggingImageState(
      ploggingImageId: int.tryParse(json['ploggingImageId']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      label: json['label'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PloggingImageState(ploggingImageId: $ploggingImageId, imageUrl: $imageUrl, createdAt: $createdAt, latitude: $latitude, longitude: $longitude, label: $label)';
  }
}
