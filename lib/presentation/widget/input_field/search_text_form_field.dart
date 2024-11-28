import 'package:flutter/material.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/matching_group_create/matching_group_create_view_model.dart';

class SearchTextFormField extends BaseWidget<MatchingGroupCreateViewModel> {
  const SearchTextFormField({Key? key}) : super(key: key);

  @override
  Widget buildView(BuildContext context) {
    return Row(
      children: [
        // Input field for group name
        Expanded(
          child: TextField(
            onChanged: viewModel.onGroupNameChanged,
            cursorColor: ColorSystem.main,
            decoration: InputDecoration(
              hintText: '그룹 이름을 입력해주세요',
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: ColorSystem.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: ColorSystem.main),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Check duplicate button
        ElevatedButton(
          onPressed: viewModel.isCheckingDuplicate ? null : viewModel.onCheckDuplicate,
          style: ElevatedButton.styleFrom(
            backgroundColor: viewModel.isCheckingDuplicate
                ? Colors.grey[400]
                : ColorSystem.main, // Disable/Enable color
            minimumSize: const Size(90, 48), // Button size
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: viewModel.isCheckingDuplicate
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            '중복확인',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
