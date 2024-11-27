import 'package:dio/dio.dart';

class PloggingImageUploadState {
  final MultipartFile ploddingImage; // 플로깅 이미지
  final double latitude; // 위도
  final double longitude; // 경도
  final int ploggingId; // 플로깅 ID

  const PloggingImageUploadState({
    required this.ploddingImage,
    required this.latitude,
    required this.longitude,
    required this.ploggingId,
  });

  // // 초기 상태
  // factory PloggingImageUploadState.initial() {
  //   return PloggingImageUploadState(
  //    ploddingImage: MultipartFile.fromFileSync(
  //      ploddingImage
  //      filename: '${DateTime.now()}.png',
  //      contentType: DioMediaType.parse('image/png'),
  //     ),
  //     latitude: 0.0,
  //     longitude: 0.0,
  //     ploggingId: 0,
  //   );
  // }

  // JSON에서 생성
  factory PloggingImageUploadState.fromJson(Map<String, dynamic> data) {
    return PloggingImageUploadState(
      ploddingImage: MultipartFile.fromFileSync(
        data['ploddingImage']?.toString() ?? '',
        filename: '${DateTime.now()}.png',
        contentType: DioMediaType.parse('image/png'),
      ),
      latitude: double.tryParse(data['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(data['longitude']?.toString() ?? '0') ?? 0.0,
      ploggingId: int.tryParse(data['ploggingId']?.toString() ?? '0') ?? 0,
    );
  }

  // 복사본 생성
  PloggingImageUploadState copyWith({
    MultipartFile? ploddingImage,
    double? latitude,
    double? longitude,
    int? ploggingId,
  }) {
    return PloggingImageUploadState(
      ploddingImage: ploddingImage ?? this.ploddingImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ploggingId: ploggingId ?? this.ploggingId,
    );
  }

  @override
  String toString() {
    return 'PloggingImageUploadState{ploddingImage: $ploddingImage, latitude: $latitude, longitude: $longitude, ploggingId: $ploggingId}';
  }
}
