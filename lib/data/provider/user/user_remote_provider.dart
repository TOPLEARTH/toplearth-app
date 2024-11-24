import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class UserRemoteProvider {
  // 사용자 정보 조회
  // /api/v1/users/me
  Future<ResponseWrapper> getUserInformation();
}
