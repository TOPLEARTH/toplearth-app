import 'package:toplearth/domain/entity/plogging/plogging_image_state.dart';

class PloggingImageListState {
  final List<PloggingImageState> ploggingImages;

  PloggingImageListState({
    required this.ploggingImages,
  });

  factory PloggingImageListState.initial() {
    return PloggingImageListState(
      ploggingImages: [],
    );
  }

  PloggingImageListState copyWith({
    List<PloggingImageState>? ploggingImages,
  }) {
    return PloggingImageListState(
      ploggingImages: ploggingImages ?? this.ploggingImages,
    );
  }

  factory PloggingImageListState.fromJson(Map<String, dynamic> json) {
    return PloggingImageListState(
      ploggingImages: (json['ploggingImages'] as List<dynamic>?)
          ?.map((image) => PloggingImageState.fromJson(image))
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'PloggingImageListState(ploggingImages: $ploggingImages)';
  }
}