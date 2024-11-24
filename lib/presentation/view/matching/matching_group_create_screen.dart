import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/presentation/view_model/matching_group_create/matching_group_create_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_back_app_bar.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/widget/input_field/search_text_form_field.dart';

class MatchingGroupCreateScreen extends BaseScreen<MatchingGroupCreateViewModel> {
  const MatchingGroupCreateScreen({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return const DefaultBackAppBar(title: "그룹 이름 입력");
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드로 인한 화면 재조정 방지
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 키보드 닫기
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group name input field
                      SearchTextFormField(),
                      const SizedBox(height: 8),
                      // Warning message below the input field
                      Text(
                        '*부적절한 그룹명은 사용에 제한이 생길 수 있습니다.',
                        style: FontSystem.Sub3.copyWith(
                          color: ColorSystem.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Create group button
              // Obx(
              //       () => Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: RoundedRectangleTextButton(
              //       width: double.infinity,
              //       text: '그룹 생성하기',
              //       backgroundColor: viewModel.isGroupNameValid && !viewModel.isCreatingGroup
              //           ? ColorSystem.main
              //           : ColorSystem.grey[300],
              //       textStyle: FontSystem.Sub2.copyWith(
              //         color: viewModel.isGroupNameValid && !viewModel.isCreatingGroup
              //             ? Colors.white
              //             : ColorSystem.grey,
              //       ),
              //       onPressed: viewModel.isGroupNameValid && !viewModel.isCreatingGroup
              //           ? viewModel.onCreateGroupPressed
              //           : null,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return    Obx(
          () => Padding(
        padding: const EdgeInsets.all(16),
        child: RoundedRectangleTextButton(
          width: double.infinity,
          text: '그룹 생성하기',
          backgroundColor: viewModel.isGroupNameValid && !viewModel.isCreatingGroup
              ? ColorSystem.main
              : ColorSystem.grey[300],
          textStyle: FontSystem.Sub2.copyWith(
            color: viewModel.isGroupNameValid && !viewModel.isCreatingGroup
                ? Colors.white
                : ColorSystem.grey,
          ),
          onPressed: viewModel.isGroupNameValid && !viewModel.isCreatingGroup
              ? viewModel.onCreateGroupPressed
              : null,
        ),
      ),
    );
  }
}
