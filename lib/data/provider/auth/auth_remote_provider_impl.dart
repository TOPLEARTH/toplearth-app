import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/data/factory/storage_factory.dart'; // FCM 토큰 가져오기 위해 추가
import 'package:toplearth/core/provider/base_socket.dart';

class AuthRemoteProviderImpl extends BaseConnect with WebSocketMixin implements AuthRemoteProvider {
  @override
  Future<ResponseWrapper> loginByDefault({
    required String email,
    required String password,
  }) async {
    // FCM 토큰 가져오기
    String? fcmToken = StorageFactory.systemProvider.getFCMToken();

    // 요청 바디에 FCM 토큰 포함
    FormData formData = FormData({
      'serial_id': email,
      'password': password,
      'fcm_token': fcmToken, // FCM 토큰 추가
    });

    Response response = await post(
      '/api/v1/auth/login',
      formData,
      headers: BaseConnect.unusedAuthorization,
    );

    return ResponseWrapper.fromJson(response.body);
  }


  @override
  Future<ResponseWrapper> loginByKakao({
    required String kakaoAccessToken,
  }) async {
    // FCM 토큰 가져오기
    String? fcmToken = StorageFactory.systemProvider.getFCMToken();
    debugPrint('FCM Token: $fcmToken');

    // 요청 바디에 FCM 토큰 포함
    Map<String, dynamic> body = {
      'fcmToken': fcmToken, // FCM 토큰 추가
    };

    Response response = await post(
      '/api/v1/auth/login/kakao',
      body,
      headers: {
        "Authorization": "Bearer $kakaoAccessToken",
      },
    );

    return ResponseWrapper.fromJson(response.body);
  }

  @override
  Future<ResponseWrapper> loginByApple({
    required String appleIdentityToken,
  }) async {
    // FCM 토큰 가져오기
    String? fcmToken = StorageFactory.systemProvider.getFCMToken();

    // 요청 바디에 FCM 토큰 포함
    Map<String, dynamic> body = {
      'fcmToken': fcmToken, // FCM 토큰 추가
    };

    Response response = await post(
      '/api/v1/auth/login/apple',
      body,
      headers: {
        "Authorization": "Bearer $appleIdentityToken",
      },
    );

    return ResponseWrapper.fromJson(response.body);
  }

  @override
  Future<ResponseWrapper> logout() async {
    // FCM 토큰 필요 시 추가
    Response response = await post(
      '/api/v1/auth/logout',
      {},
      headers: BaseConnect.usedAuthorization,
    );

    return ResponseWrapper.fromJson(response.body);
  }

  @override
  Future<ResponseWrapper> withdrawal() async {
    // FCM 토큰 필요 시 추가
    Response response = await post(
      '/api/v1/auth/withdrawal',
      {},
      headers: BaseConnect.usedAuthorization,
    );

    if (!response.hasError) {
      return ResponseWrapper.noContent();
    } else {
      return ResponseWrapper.fromJson(response.body);
    }
  }
}
