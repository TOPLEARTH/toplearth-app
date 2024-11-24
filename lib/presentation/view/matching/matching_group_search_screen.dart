import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/entity/group/group_brief_state.dart';
import 'package:toplearth/presentation/view/matching/matching_search_list_shimmer.dart';
import 'package:toplearth/presentation/view_model/matching_group_search/matching_group_search_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_back_app_bar.dart';
import 'package:toplearth/presentation/widget/dialog/two_select_dialog.dart';
import 'package:toplearth/presentation/widget/line/infinity_horizon_line.dart';

class MatchingGroupSearchScreen extends BaseScreen<MatchingGroupSearchViewModel> {
  const MatchingGroupSearchScreen({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultBackAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 검색창
            TextField(
              onChanged: viewModel.onSearchTextChanged,
              decoration: InputDecoration(
                hintText: '이름/코드를 정확히 입력해주세요!',
                prefixIcon: const Icon(Icons.search, color: ColorSystem.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: ColorSystem.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 검색 결과 및 로딩 상태 표시
            Expanded(
              child: Obx(() {
                if (viewModel.isLoading) {
                  return MatchingSearchListShimmer();
                }

                if (viewModel.groupList.isEmpty) {
                  return Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: FontSystem.Sub1.copyWith(color: ColorSystem.grey),
                    ),
                  );
                }

                return _buildGroupList(viewModel);
              }),
            ),
          ],
        ),
      ),
    );
  }
  // 검색 결과 리스트
  Widget _buildGroupList(MatchingGroupSearchViewModel viewModel) {
    return Obx(() {
      return ListView.separated(
        itemCount: viewModel.groupList.length,
        separatorBuilder: (_, __) => const InfinityHorizonLine(
          gap: 1,
          color: ColorSystem.sub2,
        ),
        itemBuilder: (_, index) {
          final group = viewModel.groupList[index];
          return InkWell(
            onTap: () {
              viewModel.selectedGroupIndex.value = index;
              Get.dialog(TwoSelectionDialog());
              // showDialog(
              //   context: context,
              //   builder: (_) => const TwoSelectionDialog(),
              // );
            },
            splashColor: ColorSystem.main.withOpacity(0.2), // 클릭 시 효과
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                children: [
                  // Group code
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorSystem.sub,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group.teamCode,
                      style: FontSystem.Sub2.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Group name with 🌏 icon
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          group.teamName,
                          style: FontSystem.Sub1.copyWith(color: ColorSystem.black),
                        ),
                        const SizedBox(width: 4),
                        const Text('🌏'),
                      ],
                    ),
                  ),
                  // Selection indicator
                  Obx(() {
                    return Icon(
                      viewModel.selectedGroupIndex.value == index
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: viewModel.selectedGroupIndex.value == index
                          ? ColorSystem.main
                          : ColorSystem.grey,
                    );
                  }),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
