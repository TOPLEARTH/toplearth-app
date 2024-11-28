import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class AuthRemoteProvider {
  Future<ResponseWrapper> loginByDefault({
    required String email,
    required String password,
  });

  // 카카오 로그인
  // /api/v1/auth/login/kakao
  Future<ResponseWrapper> loginByKakao({
    required String kakaoAccessToken,
  });

  // 애플 로그인
  // /api/v1/auth/login/apple
  Future<ResponseWrapper> loginByApple({
    required String appleIdentityToken,
  });

  // 로그아웃
  // /api/v1/auth/logout(예정)
  Future<ResponseWrapper> logout();

  // 회원탈퇴
  // /api/v1/auth/withdrawal(예정)
  Future<ResponseWrapper> withdrawal();
}
