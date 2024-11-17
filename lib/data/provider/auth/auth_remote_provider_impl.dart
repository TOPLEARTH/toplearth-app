import 'package:get/get.dart';
import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';

class AuthRemoteProviderImpl extends BaseConnect implements AuthRemoteProvider {
  @override
  Future<ResponseWrapper> loginByDefault({
    required String email,
    required String password,
  }) async {
    FormData formData = FormData({
      'serial_id': email,
      'password': password,
    });

    Response response = await post(
      '/auth/login',
      {},
      headers: BaseConnect.unusedAuthorization,
    );

    return ResponseWrapper.fromJson(response.body);
  }

  // Missing concrete implementations of 'AuthRemoteProvider.loginByApple' and 'AuthRemoteProvider.loginByKakao'

  @override
  Future<ResponseWrapper> loginByKakao({
    required String kakaoAccessToken,
  }) async {

    Response response = await post(
      '/auth/login',
      {},
      headers: {
        "Authorization": "Bearer $kakaoAccessToken",
      },
    );

    return ResponseWrapper.fromJson(response.body);
  }

  @override
  Future<ResponseWrapper> loginByApple({
    required String appleIdentityToken
  }) async {

    Response response = await post(
      '/auth/login',
      {},
      headers: {
        "Authorization": "Bearer $appleIdentityToken",
      },
    );

    return ResponseWrapper.fromJson(response.body);
  }

  @override
  Future<ResponseWrapper> logout() async {
    Response response = await post(
      '/auth/logout',
      {},
      headers: BaseConnect.usedAuthorization,
    );

    return ResponseWrapper.fromJson(response.body);
  }

  @override
  Future<ResponseWrapper> withdrawal() async {
    Response response = await post(
      '/auth/withdrawal',
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
