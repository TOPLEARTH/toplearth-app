import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/utility/log_util.dart';
import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/data/provider/plogging/plogging_remote_provider.dart';

import 'package:intl/intl.dart'; // 날짜 형식화를 위해 필요

class PloggingRemoteProviderImpl extends BaseConnect
    implements PloggingRemoteProvider {
  @override
  Future<ResponseWrapper> labelingPloggingImages({
    required File ploggingImage,
    required int ploggingId,
    required List<int> ploggingImageIds,
    required List<String> labels,
  }) async {
    try {
      // 현재 시간 기반 파일명 생성
      final now = DateTime.now();
      final formattedTime = DateFormat('yyyyMMdd_HHmmss').format(now);

      // File을 바이트로 변환하여 MultipartFile 생성
      final formData = FormData({
        'ploggingImage': MultipartFile(
          ploggingImage.readAsBytesSync(),
          filename: 'ploggingImage_$formattedTime.jpg',
          contentType: 'image/jpeg',
        ),
        'ploggingImageIds': ploggingImageIds,
        'labels': labels,
      });

      // POST 요청
      final response = await patch(
        "/api/v1/plogging/$ploggingId/labeling",
        formData,
        headers: BaseConnect.usedAuthorization,
      );

      // 응답 Wrapping
      return ResponseWrapper.fromJson(response.body);
    } catch (e) {
      return ResponseWrapper(
        success: false,
        message: '이미지 업로드 실패: $e',
      );
    }
  }

  @override
  Future<ResponseWrapper> uploadPloggingImage({
    required File ploggingImage,
    required int ploggingId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // 현재 시간 기반 파일명 생성
      final now = DateTime.now();
      final formattedTime = DateFormat('yyyyMMdd_HHmmss').format(now);

      // File을 바이트로 변환하여 MultipartFile 생성
      final formData = FormData({
        'ploggingImage': MultipartFile(
          ploggingImage.readAsBytesSync(),
          filename: 'ploggingImage_$formattedTime.jpg',
          contentType: 'image/jpeg',
        ),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      });

      // POST 요청
      final response = await post(
        "/api/v1/plogging/$ploggingId/image",
        formData,
        headers: BaseConnect.usedAuthorization,
      );

      // 응답 Wrapping
      return ResponseWrapper.fromJson(response.body);
    } catch (e) {
      return ResponseWrapper(
        success: false,
        message: '이미지 업로드 실패: $e',
      );
    }
  }

  // 개인 플로깅 시작
  @override
  Future<ResponseWrapper> startIndividualPlogging({
    required int regionId,
  }) async {
    Response response = await post(
      "/api/v1/plogging/start",
      {
        'regionId': regionId,
      },
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }

  // 팀 플로깅 종료
  @override
  Future<ResponseWrapper> finishPlogging({
    required int ploggingId,
    required double distance,
    required int duration,
    required int pickUpCnt,
    required int burnedCalories,
  }) async {
    final Map<String, dynamic> body = {
      'distance': distance,
      'duration': duration,
      'pickUpCnt': pickUpCnt,
      'burnedCalories': burnedCalories,
    };

    Response response = await patch(
      "/api/v1/plogging/$ploggingId",
      body,
      headers: BaseConnect.usedAuthorization,
    );

    print('response: $response');

    LogUtil.printJsonDataType(response.body);

    return ResponseWrapper.fromJson(response.body);
  }

  // 플로깅 신고
  @override
  Future<ResponseWrapper> reportPlogging({
    required int ploggingId,
  }) async {
    Response response = await post(
      "/api/v1/plogging/$ploggingId/reports",
      {},
      headers: BaseConnect.usedAuthorization,
    );
    return ResponseWrapper.fromJson(response.body);
  }
}
