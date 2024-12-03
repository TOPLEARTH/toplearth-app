import 'dart:io';
import 'package:dio/dio.dart';

class PloggingLabelingCondition {
  final int ploggingId; // 플로깅 ID
  final File ploggingImage; // 업로드할 스크린샷 이미지 파일
  final List<int> ploggingImageIds; // 이미지 ID 리스트
  final List<String> labels; // 라벨 리스트

  PloggingLabelingCondition({
    required this.ploggingId,
    required this.ploggingImage,
    required this.ploggingImageIds,
    required this.labels,
  });

  // FormData로 변환
  Future<FormData> toFormData() async {
    final multipartFile = await MultipartFile.fromFile(
      ploggingImage.path,
      filename: '${DateTime.now().toIso8601String()}.png', // 파일명
      contentType: DioMediaType('image', 'png'), // MIME 타입
    );

    return FormData.fromMap({
      'ploggingImage': multipartFile, // 서버에서 요구하는 키 이름
      'ploggingLabelInfo': {
        'ploggingImageIds': ploggingImageIds,
        'labels': labels,
      },
    });
  }
}
