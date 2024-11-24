import 'package:get/get.dart';
import 'package:toplearth/domain/usecase/group/join_group_usecase.dart';
import 'package:toplearth/domain/usecase/group/read_group_detail_usecase.dart';
import 'package:toplearth/domain/usecase/group/search_group_usecase.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/matching_group_search/matching_group_search_view_model.dart';

class MatchingGroupSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchGroupUseCase>(
          () => SearchGroupUseCase(),
    );
    Get.lazyPut<JoinGroupUseCase>(
          () => JoinGroupUseCase(),
    );
    Get.lazyPut<MatchingGroupSearchViewModel>(() => MatchingGroupSearchViewModel());
  }
}