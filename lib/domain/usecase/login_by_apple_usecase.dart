import 'package:get/get.dart';
import 'package:toplearth/core/usecase/async_condition_usecase.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/domain/condition/auth/login_by_apple_condition.dart';
import 'package:toplearth/domain/repository/auth_repository.dart';

class LoginByAppleUseCase extends BaseUseCase
    implements AsyncConditionUseCase<void, LoginByAppleCondition> {
  late final AuthRepository _authRepository;

  @override
  void onInit() {
    super.onInit();

    _authRepository = Get.find<AuthRepository>();
  }

  @override
  Future<StateWrapper<void>> execute(LoginByAppleCondition condition) async {
    // Login Process
    StateWrapper<Map<String, dynamic>> state =
    await _authRepository.loginByApple(condition);

    // If login failed, Guard Clause
    if (!state.success) {
      return StateWrapper<void>(
        success: state.success,
        message: state.message,
      );
    }

    // Save Json Web Token
    await StorageFactory.systemProvider.allocateTokens(
      accessToken: state.data!['access_token'],
      refreshToken: state.data!['refresh_token'],
    );

    // Return Success State
    return StateWrapper<void>(
      success: true,
      message: '로그인에 성공하였습니다.',
    );
  }
}
