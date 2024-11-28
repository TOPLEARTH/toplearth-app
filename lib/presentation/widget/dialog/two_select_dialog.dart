import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/matching_group_search/matching_group_search_view_model.dart';

class TwoSelectionDialog extends BaseWidget<MatchingGroupSearchViewModel> {
  const TwoSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget buildView(BuildContext context) {
    // Get selected group data from the viewModel
    final selectedGroupIndex = viewModel.selectedGroupIndex.value;
    final selectedGroup = viewModel.groupList[selectedGroupIndex];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "'${selectedGroup.teamName}' 그룹에 가입하시겠습니까?",
                style: FontSystem.Sub1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorSystem.black,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                "해당 그룹 팀장이 가입을 승인하면 가입이 완료됩니다.",
                style: FontSystem.Sub2.copyWith(
                  color: ColorSystem.grey,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Cancel Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorSystem.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          "취소",
                          style: FontSystem.Sub2.copyWith(
                            color: ColorSystem.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Confirm Button
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextButton(
                        onPressed: () {
                          print('teamId: ${selectedGroup.teamId}');

                          // Call joinGroup and handle the result
                          viewModel.joinGroup(selectedGroup.teamId).then((result) {
                            if (result.success) {
                              Get.snackbar('성공', '그룹에 가입 요청이 전송되었습니다.');
                              Get.toNamed(AppRoutes.GROUP_CREATE_COMPLETE, arguments: selectedGroup);
                            } else {
                              Get.snackbar('실패', result.message ?? '그룹에 가입 요청에 실패했습니다.');
                            }
                          }).catchError((error) {
                            Get.snackbar('오류', '그룹 가입 처리 중 오류가 발생했습니다: $error');
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorSystem.sub,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          "가입하기",
                          style: FontSystem.Sub2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
