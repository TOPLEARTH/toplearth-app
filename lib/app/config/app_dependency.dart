import 'package:get/get.dart';
import 'package:toplearth/core/provider/base_socket.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider.dart';
import 'package:toplearth/data/provider/auth/auth_remote_provider_impl.dart';
import 'package:toplearth/data/provider/group/group_remote_provider.dart';
import 'package:toplearth/data/provider/group/group_remote_provider_impl.dart';
import 'package:toplearth/data/provider/matching/matching_remote_provider.dart';
import 'package:toplearth/data/provider/matching/matching_remote_provider_impl.dart';
import 'package:toplearth/data/provider/plogging/plogging_remote_provider.dart';
import 'package:toplearth/data/provider/plogging/plogging_remote_provider_impl.dart';
import 'package:toplearth/data/provider/user/user_remote_provider.dart';
import 'package:toplearth/data/provider/user/user_remote_provider_impl.dart';
import 'package:toplearth/data/repository/auth_repository_impl.dart';
import 'package:toplearth/data/repository/group_repository_impl.dart';
import 'package:toplearth/data/repository/matching_repository_impl.dart';
import 'package:toplearth/data/repository/plogging_repository_impl.dart';
import 'package:toplearth/data/repository/user_repository_impl.dart';
import 'package:toplearth/domain/repository/auth/auth_repository.dart';
import 'package:toplearth/domain/repository/group/group_repository.dart';
import 'package:toplearth/domain/repository/matching/matching_repository.dart';
import 'package:toplearth/domain/repository/plogging/plogging_repository.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';

class AppDependency extends Bindings {
  @override
  void dependencies() {
    // Add your mediator dependencies here


    // Add your provider dependencies here
    Get.lazyPut(()=>WebSocketController());
    Get.lazyPut<AuthRemoteProvider>(() => AuthRemoteProviderImpl());
    Get.lazyPut<UserRemoteProvider>(() => UserRemoteProviderImpl());
    Get.lazyPut<GroupRemoteProvider>(() => GroupRemoteProviderImpl());
    Get.lazyPut<PloggingRemoteProvider>(() => PloggingRemoteProviderImpl());
    Get.lazyPut<MatchingRemoteProvider>(() => MatchingRemoteProviderImpl());


    // Add your repository dependencies here
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl());
    Get.lazyPut<GroupRepository>(() => GroupRepositoryImpl());
    Get.lazyPut<PloggingRepository>(() => PloggingRepositoryImpl());
    Get.lazyPut<MatchingRepository>(() => MatchingRepositoryImpl());
  }
}