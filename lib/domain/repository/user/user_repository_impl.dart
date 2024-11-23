

import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/user/user_remote_provider.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';

class UserRepositoryImpl extends GetxService implements UserRepository {
  late final UserRemoteProvider _userRemoteProvider;

  @override
  void onInit() {
    super.onInit();
    _userRemoteProvider = Get.find<UserRemoteProvider>();
  }

  @override
  Future<StateWrapper<UserState>> readUserState() async {
    ResponseWrapper response = await _userRemoteProvider.getUserInformation();

    StateWrapper<UserState> state;

    if(response.success){
      state = StateWrapper<UserState>(
        success: response.success,
        message: response.message,
        data: UserState.fromJson(response.data!),
      );
    } else {
      state = StateWrapper<UserState>(
        success: response.success,
        message: response.message,
      );
    }
    return state;
  }
}