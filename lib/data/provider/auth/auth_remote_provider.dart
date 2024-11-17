import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class AuthRemoteProvider {
  Future<ResponseWrapper> loginByDefault({
    required String email,
    required String password,
  });

  Future<ResponseWrapper> loginByKakao({
    required String kakaoAccessToken,
  });

  Future<ResponseWrapper> loginByApple({
    required String appleIdentityToken,
  });

  Future<ResponseWrapper> logout();

  Future<ResponseWrapper> withdrawal();
}
