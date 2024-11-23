import 'dart:async';

abstract class SystemProvider {
  /* ------------------------------------------------------------ */
  /* Initialize ------------------------------------------------- */
  /* ------------------------------------------------------------ */
  Future<void> onInit();
  Future<void> allocateTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> deallocateTokens();

  /* ------------------------------------------------------------ */
  /* Default ---------------------------------------------------- */
  /* ------------------------------------------------------------ */
  bool get isLogin;

  /* ------------------------------------------------------------ */
  /* Getter ----------------------------------------------------- */
  /* ------------------------------------------------------------ */
  bool getFirstRun();
  String getAccessToken();
  String getRefreshToken();
  String? getFCMToken(); // FCM Token Getter 추가

  /* ------------------------------------------------------------ */
  /* Setter ----------------------------------------------------- */
  /* ------------------------------------------------------------ */
  Future<void> setFirstRun(bool isFirstRun);
  Future<void> setAccessToken(String accessToken);
  Future<void> setRefreshToken(String refreshToken);
  Future<void> setFCMToken(String token); // FCM Token Setter 추가
}


extension SystemProviderExt on SystemProvider {
  // System Attributes
  static const String isFirstRun = "isFirstRun";

  // Token Attributes
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";
  static const String fcmToken = "fcmToken"; // FCM Token 추가
}

