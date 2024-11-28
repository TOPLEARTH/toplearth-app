import 'package:get/get.dart';
import 'package:toplearth/domain/type/e_group_status.dart';

class MatchingGroupViewModel extends GetxController {
  final Rx<EGroupStatus> groupStatus = EGroupStatus.notJoined.obs;

  void simulateStatusChange(EGroupStatus status) {
    groupStatus.value = status;
  }
}