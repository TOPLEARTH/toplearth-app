import 'package:get/get.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';

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
  }
}
