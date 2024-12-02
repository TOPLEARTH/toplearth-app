import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/user/boot_strap_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';

class ReadBootStrapUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<BootstrapState> {
  late final UserRepository _userRepository;

  @override
  void onInit() {
    super.onInit();
    _userRepository = Get.find<UserRepository>();
  }

  @override
  Future<StateWrapper<BootstrapState>> execute() async {
    StateWrapper<BootstrapState> state = await _userRepository.readBootStrapData();

    print('ReadBootStrapUseCase: ${state.data}');

    return state;
  }
}
