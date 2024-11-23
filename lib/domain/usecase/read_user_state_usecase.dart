import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';

class ReadUserStateUsecase extends BaseUseCase
    implements AsyncNoConditionUseCase<UserState> {
  late final UserRepository _userRepository;

  @override
  void onInit() {
    super.onInit();

    _userRepository = Get.find<UserRepository>();
  }

  @override
  Future<StateWrapper<UserState>> execute() async {
    StateWrapper<UserState> state = await _userRepository.readUserState();

    return state;
  }
}
