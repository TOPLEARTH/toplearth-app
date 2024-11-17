import 'package:get/get.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider_impl.dart';
import 'package:toplearth/data/repository/auth_repository_impl.dart';
import 'package:toplearth/domain/repository/auth_repository.dart';

class AppDependency extends Bindings {
  @override
  void dependencies() {
    // Add your mediator dependencies here
    Get.putAsync<AuthRepository>(
          () async => AuthRepositoryImpl(),
    );
    // Add your provider dependencies here
    Get.lazyPut<AuthRemoteProvider>(() => AuthRemoteProviderImpl());

    // Add your repository dependencies here
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
  }
}