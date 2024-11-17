import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/login_by_apple_usecase.dart';
import 'package:toplearth/domain/usecase/login_by_default_usecase.dart';
import 'package:toplearth/domain/usecase/login_by_kakao_usecase.dart';
import 'package:toplearth/presentation/view_model/login/login_view_model.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginByDefaultUseCase>(
      () => LoginByDefaultUseCase(),
    );

    Get.lazyPut<LoginByKakaoUseCase>(
          () => LoginByKakaoUseCase(),
    );

    Get.lazyPut<LoginByAppleUseCase>(
          () => LoginByAppleUseCase(),
    );

    Get.lazyPut<LoginViewModel>(() => LoginViewModel());
  }
}
