import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_no_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/domain/repository/auth_repository.dart';

class LogoutUseCase extends BaseUseCase
    implements AsyncNoConditionUseCase<void> {
  late final AuthRepository _authRepository;

  @override
  void onInit() {
    super.onInit();

    _authRepository = Get.find<AuthRepository>();
  }

  @override
  Future<StateWrapper<void>> execute() async {
    StateWrapper<void> state = await _authRepository.logout();

    // If logout failed, Guard Clause
    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }

    await StorageFactory.systemProvider.deallocateTokens();

    return StateWrapper<void>(
      success: true,
      message: '로그아웃에 성공하였습니다.',
    );
  }
}
