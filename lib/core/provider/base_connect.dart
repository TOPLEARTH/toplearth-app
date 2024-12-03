import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/env/common/environment.dart';
import 'package:toplearth/app/env/common/environment_factory.dart';
import 'package:toplearth/app/utility/log_util.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/data/provider/common/system_provider.dart';

abstract class BaseConnect extends GetConnect {
  static final GetHttpClient _customHttpClient = GetHttpClient();

  static final Environment _environment = EnvironmentFactory.environment;
  static final SystemProvider _systemProvider = StorageFactory.systemProvider;

  static const Map<String, String> usedInSplashScreen = {
    "usedInSplashScreen": "true",
  };

  static const Map<String, String> unusedInSplashScreen = {
    "usedInSplashScreen": "false",
  };

  static const Map<String, String> unusedAuthorization = {
    "usedAuthorization": "false",
  };

  static const Map<String, String> usedAuthorization = {
    "usedAuthorization": "true",
  };

  @override
  void onInit() {
    super.onInit();

    httpClient
      ..baseUrl = _environment.apiServerUrl
      ..defaultContentType = 'application/json; charset=utf-8'
      ..timeout = const Duration(seconds: 10);

    httpClient.addRequestModifier<dynamic>((request) {
      // 헤더 복사본 생성하여 작업
      final headers = Map<String, String>.from(request.headers);

      // 로그인 요청 체크
      if (request.url.toString().contains('/auth/login')) {
        LogUtil.info("🔑 Login request detected: ${request.url}");
        return request;
      }

      // Authorization 처리
      String? usedAuthorization = headers["usedAuthorization"];

      /// accessToken 테스트를 원한다면 여기 _systemProvider.getAccessToken()대신 토큰 삽입하세요
      if (usedAuthorization == "true") {
        // headers["Authorization"] = "Bearer ${_systemProvider.getAccessToken()}";
      }

      // headers["Authorization"] = "Bearer eyJKV1QiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOiI0YTE5MDRkZS01MmIxLTRjMmMtOTk4NS1lNGFkMDYxN2VkYzIiLCJ1c2VyUm9sZSI6IlVTRVIiLCJpYXQiOjE3MzMwNzcxODksImV4cCI6MTczNTY2OTE4OX0.0jCR6iAnolddX4nkcv2jHnpnE75jTwy9vS2--gWnddFrcJ4p-ykR3pq7fWFQxgQnBf10rL0Yn1pz7kxLDnmmmg";

      headers["Authorization"] =
          "Bearer eyJKV1QiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VySWQiOiJiMjc1YmJmNy0xN2Y5LTQ0OTMtOGRlYi1kOTBiNzVmZjA2NTgiLCJ1c2VyUm9sZSI6IlVTRVIiLCJpYXQiOjE3MzI0NDE1NDAsImV4cCI6MTczNTAzMzU0MH0.vJVHdSLY0QoE5wt08Tv6_8zJywpyo3vp9MkloY0TVZYq5RBpdn_MiTMbWI8DCemowYHuMWfdwC4L63KCQTaeYg";

      debugPrint('current accessToken: ${_systemProvider.getAccessToken()}');

      // Splash Screen 처리
      if (!headers.containsKey("usedInSplashScreen")) {
        headers["usedInSplashScreen"] = "false";
      }

      // 로깅
      LogUtil.info(
        "🛫 [${request.method}] ${request.url} | START",
      );
      LogUtil.info("Headers: $headers");

      // 헤더 한번에 교체
      request.headers.clear();
      request.headers.addAll(headers);

      return request;
    });

    httpClient.addResponseModifier((request, Response response) async {
      if (response.status.hasError) {
        // 에러 응답 로깅
        LogUtil.error(
          "🚨 [${request.method}] ${request.url} | END",
        );
        LogUtil.error(
          "Error: ${response.body['error']}",
        );

        await _isExpiredTokens(
          request: request,
          statusCodeOrErrorCode: response.body['error']['code'],
        );
      } else {
        LogUtil.info(
          "🛬 [${request.method}] ${request.url} | END ${response.body}",
        );
      }

      return response;
    });

    httpClient.addAuthenticator<dynamic>((request) async {
      if (request.url.toString().contains("login")) {
        return request;
      }

      Response reissueResponse = await _reissueToken();

      if (!reissueResponse.hasError) {
        await _systemProvider.allocateTokens(
          accessToken: reissueResponse.body['data']['accessToken'],
          refreshToken: reissueResponse.body['data']['refreshToken'],
        );
      } else {
        await _isExpiredTokens(
          request: request,
          statusCodeOrErrorCode: reissueResponse.statusCode!,
        );
      }

      return request;
    });

    httpClient.maxAuthRetries = 1;
  }

  Future<Response<dynamic>> _reissueToken() async {
    String refreshToken = _systemProvider.getRefreshToken();

    Response response;

    try {
      response = await _customHttpClient.post(
        "${_environment.apiServerUrl}/auth/reissue/token",
        contentType: 'application/json; charset=utf-8',
        headers: {
          "Authorization": "Bearer $refreshToken",
        },
      );
    } catch (e) {
      response = const Response(
        statusCode: 401,
      );
    }

    return response;
  }

  Future<void> _isExpiredTokens({
    required Request<dynamic> request,
    required int statusCodeOrErrorCode,
  }) async {
    String usedInSplashScreen = request.headers["usedInSplashScreen"]!;

    if ((statusCodeOrErrorCode == 401 || statusCodeOrErrorCode == 40402) &&
        usedInSplashScreen == 'false') {
      await StorageFactory.systemProvider.deallocateTokens();

      Get.snackbar(
        "로그인 만료",
        "로그인이 만료되었습니다. 다시 로그인해주세요.",
      );

      Get.offAllNamed(AppRoutes.ROOT);
    }
  }

  @protected
  String get accessToken => _systemProvider.getAccessToken();
}
