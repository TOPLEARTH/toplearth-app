import 'package:get/get.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';

class MatchingGroupCreateCompleteViewModel extends GetxController {
  late final String groupName;
  late final String groupCode;
  late final String inviterName;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as GroupBriefState;
    groupName = args.teamName;
    groupCode = args.teamCode;

    final homeViewModel = Get.find<HomeViewModel>();
    inviterName = homeViewModel.userState.nickname;

    _triggerRootViewModelUpdates();
  }

  void _triggerRootViewModelUpdates() {
    final rootViewModel = Get.find<RootViewModel>();

    rootViewModel.fetchMatchingStatus();
    rootViewModel.fetchBootstrapInformation();
  }
}
