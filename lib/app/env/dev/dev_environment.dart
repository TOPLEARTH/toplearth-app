import 'package:envied/envied.dart';
import 'package:toplearth/app/env/common/environment.dart';

part 'dev_environment.g.dart';

@Envied(path: './assets/config/.dev.env')
class DevEnvironment implements Environment {
  @EnviedField(varName: 'API_SERVER_URL', defaultValue: '', obfuscate: true)
  static final String API_SERVER_URL = _DevEnvironment.API_SERVER_URL;

  @EnviedField(varName: 'SOCKET_SERVER_URL', defaultValue: '', obfuscate: true)
  static final String SOCKET_SERVER_URL = _DevEnvironment.SOCKET_SERVER_URL;

  @EnviedField(varName: 'NAVER_CLIENT_ID')
  static const String NAVER_CLIENT_ID = _DevEnvironment.NAVER_CLIENT_ID;

  @EnviedField(varName: 'NAVER_CLIENT_SECRET')
  static const String NAVER_CLIENT_SECRET = _DevEnvironment.NAVER_CLIENT_SECRET;

  @EnviedField(varName: 'KAKAO_APP_KEY')
  static const String KAKAO_APP_KEY = _DevEnvironment.KAKAO_APP_KEY;

  @override
  String get apiServerUrl => API_SERVER_URL;

  @override
  String get naverClientId => NAVER_CLIENT_ID;

  @override
  String get naverClientSecret => NAVER_CLIENT_SECRET;

  @override
  String get kakaoAppKey => KAKAO_APP_KEY;

  @override
  String get socketServerUrl => SOCKET_SERVER_URL;
}