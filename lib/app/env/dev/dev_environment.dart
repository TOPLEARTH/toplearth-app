import 'package:envied/envied.dart';
import 'package:toplearth/app/env/common/environment.dart';

part 'dev_environment.g.dart';

@Envied(path: './assets/config/.dev.env')
class DevEnvironment implements Environment {
  @EnviedField(varName: 'API_SERVER_URL', defaultValue: '', obfuscate: true)
  static final String API_SERVER_URL = _DevEnvironment.API_SERVER_URL;

  @EnviedField(varName: 'NAVER_CLIENT_ID')
  static const String NAVER_CLIENT_ID = _DevEnvironment.NAVER_CLIENT_ID;

  @override
  String get apiServerUrl => API_SERVER_URL;

  @override
  String get naverClientId => NAVER_CLIENT_ID;
}