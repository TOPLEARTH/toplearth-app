import 'dart:io';
import 'package:dio/dio.dart';

class UploadPloggingImageCondition {
  final File ploddingImage;
  final int ploggingId;
  final double latitude;
  final double longitude;

  UploadPloggingImageCondition({
    required this.ploddingImage,
    required this.ploggingId,
    required this.latitude,
    required this.longitude,
  });

  /// FormData를 반환하는 메서드 추가
  Future<FormData> toFormData() async {
    final multipartFile = await MultipartFile.fromFile(
      ploddingImage.path,
      filename: '${DateTime.now().toIso8601String()}.png',
      contentType: DioMediaType('image', 'png'),
    );

    return FormData.fromMap({
      'ploggingImage': multipartFile,
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
