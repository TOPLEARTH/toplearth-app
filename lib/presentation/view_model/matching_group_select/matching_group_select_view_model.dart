import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/core/usecase/common/base_usecase.dart';
import 'package:toplearth/core/wrapper/result_wrapper.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/group/join_group_condition.dart';
import 'package:toplearth/domain/condition/group/search_group_condition.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/domain/usecase/group/join_group_usecase.dart';
import 'package:toplearth/domain/usecase/group/search_group_usecase.dart';

class MatchingGroupSearchViewModel extends GetxController {
  late final SearchGroupUseCase _searchGroupUseCase;
  late final JoinGroupUseCase _joinGroupUseCase;

  // Observable fields
  final RxList<GroupBriefState> _groupList = <GroupBriefState>[].obs;
  final RxBool _isLoading = false.obs;
  final RxInt selectedGroupIndex = (-1).obs; // For tracking selected group index

  // Debouncer for handling search input
  final Debouncer<String> debouncer = Debouncer<String>(
    const Duration(seconds: 1), // Debounce duration: 1 second
    initialValue: '',
  );

  // Public getters
  List<GroupBriefState> get groupList => _groupList;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _searchGroupUseCase = Get.find<SearchGroupUseCase>();
    _joinGroupUseCase = Get.find<JoinGroupUseCase>();

    debouncer.values.listen((searchText) {
      _fetchGroupList(searchText);
    });
  }

  Future<ResultWrapper> joinGroup(int teamId) async {
    StateWrapper<void> state = await _joinGroupUseCase.execute(
      JoinGroupCondition(teamId: teamId),
    );

    return ResultWrapper(
      success: state.success,
      message: state.message,
    );
  }




  Future<void> _fetchGroupList(String searchText) async {
    if (searchText.isEmpty) {
      _groupList.clear();
      return;
    }

    _isLoading.value = true;

    // Add minimum shimmer delay (1 second)
    await Future.delayed(Duration(seconds: 1));

    final result = await _searchGroupUseCase.execute(
      SearchGroupCondition(text: searchText),
    );

    _groupList.assignAll(result.data ?? []);
    _isLoading.value = false;
  }

  void onSearchTextChanged(String text) {
    debouncer.notify(text); // Notify debouncer with updated text
  }
}
