import 'package:get/get.dart';
import 'package:toplearth/core/provider/base_connect.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/data/provider/user/user_remote_provider.dart'; // FCM 토큰 가져오기 위해 추가

class UserRemoteProviderImpl extends BaseConnect implements UserRemoteProvider {
  @override
  Future<ResponseWrapper> getBootStrapInformation() async {
    Response response = await get(
      '/api/v1/bootstrap',
      headers: BaseConnect.usedAuthorization,
    );

    return ResponseWrapper.fromJson(response.body);
  }
}