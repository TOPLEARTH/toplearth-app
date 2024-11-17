import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider.dart';
import 'package:toplearth/domain/condition/auth/login_by_apple_condition.dart';
import 'package:toplearth/domain/condition/auth/login_by_default_condition.dart';
import 'package:toplearth/domain/condition/auth/login_by_kakao_condition.dart';
import 'package:toplearth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends GetxService implements AuthRepository {
  late final AuthRemoteProvider _authProvider;

  @override
  void onInit() {
    super.onInit();

    _authProvider = Get.find<AuthRemoteProvider>();
  }

  @override
  Future<StateWrapper<Map<String, dynamic>>> loginByDefault(
    LoginByDefaultCondition condition,
  ) async {
    ResponseWrapper response = await _authProvider.loginByDefault(
      email: condition.email,
      password: condition.password,
    );

    Map<String, dynamic>? data = response.data;

    return StateWrapper(
      success: response.success,
      message: response.message,
      data: data,
    );
  }

  @override
  Future<StateWrapper<Map<String, dynamic>>> loginByKakao(
      LoginByKakaoCondition condition,
      ) async {
    ResponseWrapper response = await _authProvider.loginByKakao(
        kakaoAccessToken: condition.kakaoAccessToken
    );

    Map<String, dynamic>? data = response.data;

    return StateWrapper(
      success: response.success,
      message: response.message,
      data: data,
    );
  }

  @override
  Future<StateWrapper<Map<String, dynamic>>> loginByApple(
      LoginByAppleCondition condition,
      ) async {
    ResponseWrapper response = await _authProvider.loginByApple(
        appleIdentityToken: condition.appleIdentityToken
    );

    Map<String, dynamic>? data = response.data;

    return StateWrapper(
      success: response.success,
      message: response.message,
      data: data,
    );
  }


  @override
  Future<StateWrapper<void>> logout() async {
    ResponseWrapper response = await _authProvider.logout();

    return StateWrapper(
      success: response.success,
      message: response.message,
    );
  }

  @override
  Future<StateWrapper<void>> withdrawal() async {
    ResponseWrapper response = await _authProvider.withdrawal();

    return StateWrapper(
      success: response.success,
      message: response.message,
    );
  }
}
