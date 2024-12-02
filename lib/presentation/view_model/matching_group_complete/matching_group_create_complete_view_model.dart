import 'package:get/get.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class MatchingGroupCreateCompleteViewModel extends GetxController {
  // Group details passed from the previous screen
  late final String groupName;
  late final String groupCode;
  late final String inviterName;

  @override
  void onInit() {
    super.onInit();
    // Retrieve data from arguments (sent by the previous screen)
    final args = Get.arguments as GroupBriefState;
    groupName = args.teamName;
    groupCode = args.teamCode;
    inviterName = "이도형"; // Replace with actual inviter name if available

    // RootViewModel 트리거 호출
    _triggerRootViewModelUpdates();
  }

  void _triggerRootViewModelUpdates() {
    final rootViewModel = Get.find<RootViewModel>();

    // _fetchBootstrapInformation 호출
    rootViewModel.fetchMatchingStatus();
    rootViewModel.fetchBootstrapInformation();
    // rootViewModel.fetchBootstrapInformation();
  }
}
