import 'package:toplearth/domain/type/e_labeling_status.dart';

class PloggingImageState {
  final String ploggingImageId;
  final String imageUrl;
  final DateTime createdAt; // Fixed type to DateTime
  final double latitude;
  final double longitude;
  // final ELabelingStatus label;
 final String label; // Fixed type to String

  const PloggingImageState({
    required this.ploggingImageId,
    required this.imageUrl,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  PloggingImageState copyWith({
    String? ploggingImageId, // Correct type
    String? imageUrl,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    // ELabelingStatus? label,
    String? label, // Correct type
  }) {
    return PloggingImageState(
      ploggingImageId: ploggingImageId ?? this.ploggingImageId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      // label: label ?? this.label,
      label: label ?? this.label,
    );
  }

  factory PloggingImageState.initial() {
    return PloggingImageState(
      ploggingImageId: "0", // Correct type, default to "0
      imageUrl: '',
      createdAt: DateTime.now(), // Correct type
      latitude: 0.0,
      longitude: 0.0,
      label: 'OTHERS', // Default to 'others
      // label: ELabelingStatus.others, // Default to 'others'
    );
  }

  factory PloggingImageState.fromJson(Map<String, dynamic> json) {
    return PloggingImageState(
      ploggingImageId: json['ploggingImageId'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String), // Parse DateTime
      latitude: (json['latitude'] as num).toDouble(), // Ensure double conversion
      longitude: (json['longitude'] as num).toDouble(), // Ensure double conversion
      label: json['label'] as String, // Correct type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ploggingImageId': ploggingImageId,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(), // Correct for DateTime
      'latitude': latitude,
      'longitude': longitude,
      'label': label,
    };
  }

  @override
  String toString() {
    return 'PloggingImageState(ploggingImageId: $ploggingImageId, imageUrl: $imageUrl, createdAt: $createdAt, latitude: $latitude, longitude: $longitude, label: $label)';
  }
}
