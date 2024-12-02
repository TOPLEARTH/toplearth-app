import 'package:get/get.dart';
import 'package:toplearth/app/utility/log_util.dart';
import 'package:toplearth/core/wrapper/response_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/provider/user/user_remote_provider.dart';
import 'package:toplearth/domain/entity/user/boot_strap_state.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';

class UserRepositoryImpl extends GetxService implements UserRepository {
  late final UserRemoteProvider _userRemoteProvider;

  @override
  void onInit() {
    super.onInit();

    _userRemoteProvider = Get.find<UserRemoteProvider>();
  }

  @override
  Future<StateWrapper<BootstrapState>> readBootStrapData() async {
    ResponseWrapper response = await _userRemoteProvider.getBootStrapInformation();

    if (!response.success) {
      return StateWrapper(
        success: false,
        message: response.message,
      );
    }

    LogUtil.info('Bootstrap data: ${response.data}');

    BootstrapState state = BootstrapState.fromJson(response.data!);

    return StateWrapper.fromResponseAndState(response, state);
  }
}
