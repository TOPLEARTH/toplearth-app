import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/auth/login_by_apple_condition.dart';
import 'package:toplearth/domain/condition/auth/login_by_default_condition.dart';
import 'package:toplearth/domain/condition/auth/login_by_kakao_condition.dart';
import 'package:toplearth/domain/usecase/login_by_apple_usecase.dart';
import 'package:toplearth/domain/usecase/login_by_default_usecase.dart';
import 'package:toplearth/domain/usecase/login_by_kakao_usecase.dart';
import 'package:toplearth/app/utility/log_util.dart';

class LoginViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* Static Fields ---------------------------------------- */
  /* ------------------------------------------------------ */
  static const String _emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /* ------------------------------------------------------ */
  /* DI Fields -------------------------------------------- */
  /* ------------------------------------------------------ */
  late final LoginByDefaultUseCase _loginByDefaultUsecase;
  late final LoginByKakaoUseCase _loginByKakaoUsecase;
  late final LoginByAppleUseCase _loginByAppleUsecase;

  /* ------------------------------------------------------ */
  /* Private Fields --------------------------------------- */
  /* ------------------------------------------------------ */
  late final RxBool _isEnableLoginButton;
  late final RxBool _isEnableGreyBarrier;

  late final RxString _emailStr;
  late final RxString _passwordStr;

  /* ------------------------------------------------------ */
  /* Public Fields ---------------------------------------- */
  /* ------------------------------------------------------ */
  bool get isEnableLoginButton => _isEnableLoginButton.value;
  bool get isEnableGreyBarrier => _isEnableGreyBarrier.value;

  String get emailStr => _emailStr.value;
  String get passwordStr => _passwordStr.value;

  /* ------------------------------------------------------ */
  /* Method ----------------------------------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();

    // Dependency Injection
    _loginByDefaultUsecase = Get.find<LoginByDefaultUseCase>();
    _loginByKakaoUsecase = Get.find<LoginByKakaoUseCase>();
    _loginByAppleUsecase = Get.find<LoginByAppleUseCase>();

    // Initialize Private Fields
    _isEnableLoginButton = false.obs;
    _isEnableGreyBarrier = false.obs;

    _emailStr = ''.obs;
    _passwordStr = ''.obs;
  }

  void onChangedEmail(String value) {
    _emailStr.value = value;

    _isEnableLoginButton.value = isValidStrings();
  }

  void onChangedPassword(String value) {
    _passwordStr.value = value;

    _isEnableLoginButton.value = isValidStrings();
  }

  bool isValidStrings() {
    bool isValidEmail = _emailStr.value.isNotEmpty &&
        RegExp(_emailRegex).hasMatch(_emailStr.value);

    bool isValidPassword =
        _passwordStr.value.isNotEmpty && _passwordStr.value.length >= 8;

    return isValidEmail && isValidPassword;
  }

  Future<ResultWrapper> loginByDefault() async {
    StateWrapper<void> result = await _loginByDefaultUsecase.execute(
      LoginByDefaultCondition(
        email: emailStr,
        password: passwordStr,
      ),
    );

    return ResultWrapper(success: result.success, message: result.message);
  }

  Future<ResultWrapper> loginByKakao() async {
    _isEnableGreyBarrier.value = true;

    try {
      final kakaoAccessToken = await _fetchKakaoAccessToken();

      StateWrapper<void> result = await _loginByKakaoUsecase.execute(
        LoginByKakaoCondition(kakaoAccessToken: kakaoAccessToken),
      );

      _isEnableGreyBarrier.value = false;
      return ResultWrapper(success: result.success, message: result.message);
    } catch (e) {
      _isEnableGreyBarrier.value = false;
      return ResultWrapper(success: false, message: '카카오 로그인 실패: $e');
    }
  }

  Future<ResultWrapper> loginByApple() async {
    _isEnableGreyBarrier.value = true;

    try {
      final appleIdentityToken = await _fetchAppleIdentityToken();

      StateWrapper<void> result = await _loginByAppleUsecase.execute(
        LoginByAppleCondition(appleIdentityToken: appleIdentityToken),
      );

      _isEnableGreyBarrier.value = false;
      return ResultWrapper(success: result.success, message: result.message);
    } catch (e) {
      _isEnableGreyBarrier.value = false;
      return ResultWrapper(success: false, message: 'Apple 로그인 실패: $e');
    }
  }

  Future<String> _fetchKakaoAccessToken() async {
    OAuthToken token;

    if (await isKakaoTalkInstalled()) {
      LogUtil.info('카카오톡 설치 확인됨. 카카오톡으로 로그인 시도.');
      token = await UserApi.instance.loginWithKakaoTalk();
    } else {
      LogUtil.info('카카오톡 미설치. 카카오 계정으로 로그인 시도.');
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    LogUtil.info('Kakao Access Token: ${token.accessToken}');
    return token.accessToken;
  }

  Future<String> _fetchAppleIdentityToken() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    LogUtil.info('Apple Identity Token: ${credential.identityToken}');
    return credential.identityToken!;
  }
}
