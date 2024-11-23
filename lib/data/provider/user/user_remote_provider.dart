import 'package:toplearth/core/wrapper/response_wrapper.dart';

abstract class UserRemoteProvider {
  Future<ResponseWrapper> getUserInformation();
}
