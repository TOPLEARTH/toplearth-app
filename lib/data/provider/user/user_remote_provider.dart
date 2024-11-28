import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';

abstract class UserRemoteProvider {
  // 부트스트랩 정보 가져오기
  // /api/v1/bootstrap
  Future<ResponseWrapper> getBootStrapInformation();
}
