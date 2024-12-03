import 'package:toplearth/domain/entity/plogging/plogging_image_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_no_label_state.dart';

class PloggingImageListState {
  final List<PloggingNoLabelState> ploggingImages;

  PloggingImageListState({
    required this.ploggingImages,
  });

  factory PloggingImageListState.initial() {
    return PloggingImageListState(
      ploggingImages: [],
    );
  }

  PloggingImageListState copyWith({
    List<PloggingNoLabelState>? ploggingImages,
  }) {
    return PloggingImageListState(
      ploggingImages: ploggingImages ?? this.ploggingImages,
    );
  }

  factory PloggingImageListState.fromJson(Map<String, dynamic> json) {
    return PloggingImageListState(
      ploggingImages: (json['ploggingImages'] as List<dynamic>?)
          ?.map((image) => PloggingNoLabelState.fromJson(image))
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'PloggingImageListState{ploggingImages: $ploggingImages}';
  }
}