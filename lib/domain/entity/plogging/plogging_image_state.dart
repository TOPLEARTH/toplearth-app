class PloggingImageState {
  final int ploggingImageId;
  final String imageUrl;
  final String createdAt;

  const PloggingImageState({
    required this.ploggingImageId,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PloggingImageState.fromJson(Map<String, dynamic> json) {
    return PloggingImageState(
      ploggingImageId: int.tryParse(json['ploggingImageId']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PloggingImageState(ploggingImageId: $ploggingImageId, imageUrl: $imageUrl, createdAt: $createdAt)';
  }
}
