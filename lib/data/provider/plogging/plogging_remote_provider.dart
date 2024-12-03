import 'dart:io';

import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class PloggingRemoteProvider {
  // 플로깅중 이미지 업로드
  // /api/v1/plogging/{ploggingId}/image
  Future<ResponseWrapper> uploadPloggingImage({
    required File ploggingImage, // 플로깅 이미지
    required int ploggingId, // 플로깅 ID
    required double latitude, // 위도
    required double longitude, // 경도
  });

  // 개인 플로깅 시작
  // /api/v1/plogging/start
  Future<ResponseWrapper> startIndividualPlogging({
    required int regionId, // 지역구 ID
  });

  // 플로깅 종료
  // /api/v1/plogging/{plogginId}
  Future<ResponseWrapper> finishPlogging({
    required int ploggingId, // 플로깅 ID
    required double distance, // 이동거리
    required int duration, // 이동시간
    required int pickUpCnt, // 쓰레기 줍은 횟수
    required int burnedCalories, // 소모 칼로리
  });

  // 플로깅 이미지 라벨링
  // /api/v1/plogging/$ploggingId
  Future<ResponseWrapper> labelingPloggingImages({
    required int ploggingId,
    required File ploggingImage, // 플로깅 이미지
    required List<int> ploggingImageIds,
    required List<String> labels,
  });

  // 플로깅 신고
  // /api/v1/plogging/{ploggingId}/reports
  Future<ResponseWrapper> reportPlogging({
    required int ploggingId, // 플로깅 ID
  });
}
