import 'package:get/get.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/condition/group/create_group_condition.dart';
import 'package:toplearth/domain/usecase/group/create_group_usecase.dart';

class MatchingGroupCreateViewModel extends GetxController {
  /* DI Fields */
  late final CreateGroupUseCase _createGroupUseCase;

  /* Private Fields */
  late final RxString _groupName;
  late final RxBool _isGroupNameValid;
  late final RxBool _isCheckingDuplicate;
  late final RxBool _isCreatingGroup;

  /* Public Fields */
  String get groupName => _groupName.value;
  bool get isGroupNameValid => _isGroupNameValid.value;
  bool get isCheckingDuplicate => _isCheckingDuplicate.value;
  bool get isCreatingGroup => _isCreatingGroup.value;

  @override
  void onInit() {
    super.onInit();
    _createGroupUseCase = Get.find<CreateGroupUseCase>();

    _groupName = ''.obs;
    _isGroupNameValid = false.obs;
    _isCheckingDuplicate = false.obs;
    _isCreatingGroup = false.obs;
  }

  void onGroupNameChanged(String name) {
    _groupName.value = name;
    _isGroupNameValid.value = name.isNotEmpty && name.length <= 20;
  }

  Future<void> onCheckDuplicate() async {
    if (!_isGroupNameValid.value) {
      Get.snackbar('오류', '그룹 이름을 올바르게 입력해주세요.');
      return;
    }

    _isCheckingDuplicate.value = true;

    // Simulated duplicate check logic
    await Future.delayed(const Duration(seconds: 1)); // Simulated API call
    final isAvailable = nameIsAvailable(_groupName.value);

    _isCheckingDuplicate.value = false;

    if (isAvailable) {
      Get.snackbar('확인 완료', '사용 가능한 그룹 이름입니다.');
    } else {
      Get.snackbar('중복됨', '이미 사용 중인 그룹 이름입니다.');
    }
  }

  Future<void> onCreateGroupPressed() async {
    if (!isGroupNameValid) {
      Get.snackbar('오류', '유효한 그룹 이름을 입력해주세요.');
      return;
    }

    _isCreatingGroup.value = true;

    try {
      // Create group using the use case
      final result = await _createGroupUseCase.execute(
        CreateGroupCondition(teamName: _groupName.value),
      );

      if (result.success) {
        Get.snackbar('성공', '그룹 생성에 성공했습니다!');
        // Navigate to the desired screen or handle post-success actions
      } else {
        Get.snackbar('실패', result.message ?? '그룹 생성에 실패했습니다.');
      }
    } catch (e) {
      Get.snackbar('오류', '그룹 생성 중 오류가 발생했습니다: $e');
    } finally {
      _isCreatingGroup.value = false;
    }
  }

  bool nameIsAvailable(String name) {
    // Replace with actual API logic
    return name != "중복된이름";
  }
}
