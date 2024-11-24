import 'package:get/get.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider_impl.dart';
import 'package:toplearth/data/provider/group/group_remote_provider.dart';
import 'package:toplearth/data/provider/group/group_remote_provider_impl.dart';
import 'package:toplearth/data/provider/user/user_remote_provider.dart';
import 'package:toplearth/data/provider/user/user_remote_provider_impl.dart';
import 'package:toplearth/data/repository/auth_repository_impl.dart';
import 'package:toplearth/data/repository/group_repository_impl.dart';
import 'package:toplearth/domain/repository/auth/auth_repository.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';
import 'package:toplearth/domain/repository/user/user_repository_impl.dart';

class AppDependency extends Bindings {
  @override
  void dependencies() {
    // Add your mediator dependencies here


    // Add your provider dependencies here
    Get.lazyPut<AuthRemoteProvider>(() => AuthRemoteProviderImpl());
    Get.lazyPut<UserRemoteProvider>(() => UserRemoteProviderImpl());
    Get.lazyPut<GroupRemoteProvider>(() => GroupRemoteProviderImpl());

    // Add your repository dependencies here
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl());
    Get.lazyPut<GroupRepository>(() => GroupRepositoryImpl());
  }
}