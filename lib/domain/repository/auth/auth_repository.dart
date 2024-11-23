import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/auth/login_by_apple_condition.dart';
import 'package:toplearth/domain/condition/auth/login_by_default_condition.dart';
import 'package:toplearth/domain/condition/auth/login_by_kakao_condition.dart';

abstract class AuthRepository {
  Future<StateWrapper<Map<String, dynamic>>> loginByDefault(
      LoginByDefaultCondition condition,
      );

  Future<StateWrapper<Map<String, dynamic>>> loginByKakao(
      LoginByKakaoCondition condition,
      );

  Future<StateWrapper<Map<String, dynamic>>> loginByApple(
      LoginByAppleCondition condition,
      );

  Future<StateWrapper<void>> logout();

  Future<StateWrapper<void>> withdrawal();
}
