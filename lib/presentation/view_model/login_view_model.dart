// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:toplearth/app/utility/log_util.dart';
//
//
// abstract class AuthRepository {
//   Future<bool> loginWithKakaoAccessToken(String accessToken);
// }
//
// class LoginViewModel extends GetxController {
//   /* ------------------------------------------------------ */
//   /* -------------------- DI Fields ----------------------- */
//   /* ------------------------------------------------------ */
//   late final AuthRepository _authRepository;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Private Fields --------------------- */
//   /* ------------------------------------------------------ */
//   late final RxBool _isEnableGreyBarrier;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Public Fields ---------------------- */
//   /* ------------------------------------------------------ */
//   bool get isEnableGreyBarrier => _isEnableGreyBarrier.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Dependency Injection
//     _authRepository = Get.find<AuthRepository>();
//
//     // Initialize Private Fields
//     _isEnableGreyBarrier = false.obs;
//   }
//
//   Future<bool> kakaoSignInAccount() async {
//     debugPrint('카카오 로그인 시작.');
//
//     String kakaoAccessToken;
//
//     try {
//       OAuthToken token;
//       if (await isKakaoTalkInstalled()) {
//         debugPrint('카카오톡 설치 확인됨. 카카오톡으로 로그인 시도.');
//         token = await UserApi.instance.loginWithKakaoTalk();
//       } else {
//         debugPrint('카카오톡 미설치. 카카오 계정으로 로그인 시도.');
//         token = await UserApi.instance.loginWithKakaoAccount();
//       }
//
//       kakaoAccessToken = token.accessToken;
//       debugPrint('카카오 액세스 토큰: $kakaoAccessToken');
//     } catch (error) {
//       debugPrint('카카오 로그인 에러: $error');
//       return false; // 로그인 실패
//     }
//
//     LogUtil.info('Kakao Access Token: $kakaoAccessToken');
//     _isEnableGreyBarrier.value = true;
//
//     debugPrint('서버에 액세스 토큰으로 로그인 요청.');
//     bool result = await _authRepository.loginWithKakaoAccessToken(kakaoAccessToken);
//     _isEnableGreyBarrier.value = false;
//
//     if (result) {
//       debugPrint('서버 로그인 성공.');
//     } else {
//       debugPrint('서버 로그인 실패.');
//     }
//
//     return result;
//   }
//
// }
