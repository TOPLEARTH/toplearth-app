import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/TextToEmoji.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/entity/group/member_state.dart';
import 'package:toplearth/presentation/view_model/group/group_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';

// 뷰모델 익히기용
class GroupScreen extends BaseScreen<GroupViewModel> {
  const GroupScreen({super.key});

  @override
  Color get unSafeAreaColor => ColorSystem.blue;

  @override
  bool get setTopOuterSafeArea => true;

  @override
  bool get setBottomOuterSafeArea => false;

  @override
  bool get extendBodyBehindAppBar => false; // SafeArea를 넘지 않도록 설정

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //그룹 정보
              _buildGroupInfoSection(),
              const SizedBox(height: 16),
              //승률 및 팀원 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMemberList(),
                  _buildCircularProgressBar(),
                ],
              ),
              _buildDistanceList(),
              _buildLabeledTrash(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupInfoSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 추가
          children: [
            const Text("그룹 정보", style: FontSystem.H3),
            Text("그룹 탈퇴하기",
                style: FontSystem.Sub1.copyWith(color: ColorSystem.grey)),
          ],
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow("그룹명 🌏", viewModel.teamInfoState.teamName),
                _buildInfoRow("그룹코드 🌿", viewModel.teamInfoState.teamCode),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 추가
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: FontSystem.Sub2),
        const SizedBox(height: 4),
        Text(value, style: FontSystem.Sub2.copyWith(color: ColorSystem.grey)),
      ],
    );
  }

  Widget _buildMemberList() {
    // Get the team members from the ViewModel

    if (viewModel.teamInfoState.teamMemebers.isEmpty) {
      return const SizedBox
          .shrink(); // Return an empty widget if no members exist
    }

    return Obx(
      () => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: 242,
          width: 160,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('팀원', style: FontSystem.H2),
                const SizedBox(height: 12),
                // Render each member row
                ...viewModel.teamInfoState.teamMemebers
                    .map((member) => _buildMemberRow(member))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(MemberState member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            member.name,
            style: FontSystem.H4,
          ),
          const SizedBox(width: 8),
          if (member.role == 'LEADER')
            const Icon(Icons.manage_accounts, size: 28, color: ColorSystem.main)
        ],
      ),
    );
  }

  Widget _buildCircularProgressBar() {
    double winRate = viewModel.teamInfoState.matchCnt > 0
        ? (viewModel.teamInfoState.winCnt / viewModel.teamInfoState.matchCnt)
        : 0.0;
    double winRate100 = viewModel.teamInfoState.matchCnt > 0
        ? (viewModel.teamInfoState.winCnt / viewModel.teamInfoState.matchCnt) *
            100
        : 0.0;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("팀 승률", style: FontSystem.H3),
            const SizedBox(height: 47),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: winRate,
                  strokeWidth: 20,
                  strokeAlign: 3,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(ColorSystem.main),
                  backgroundColor: ColorSystem.grey[300],
                ),
                Text("$winRate100%", style: FontSystem.H3),
              ],
            ),
            const SizedBox(height: 47),
            Text(
              "${viewModel.teamInfoState.matchCnt}개의 대결 중\n${viewModel.teamInfoState.winCnt}경기를 이겼어요!",
              style: FontSystem.Sub2.copyWith(color: ColorSystem.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceList() {
    if (viewModel.currentMonthData == null) {
      return const Center(child: Text("이번 달 데이터가 없습니다."));
    }

    final members = viewModel.currentMonthData!.members;

    // Sort members by distance in descending order
    members.sort((a, b) => b.distance.compareTo(a.distance));

    final maxDistance = members.first.distance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("팀원별 이동 거리", style: FontSystem.H3),
        const SizedBox(height: 16),
        ...members.map(
          (member) {
            final progress = member.distance / maxDistance;
            String medal = '';

            // Assign medals based on rank
            final index = members.indexOf(member);
            if (index == 0)
              medal = '🥇';
            else if (index == 1)
              medal = '🥈';
            else if (index == 2) medal = '🥉';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$medal ${member.name}',
                      style: FontSystem.H4.copyWith(color: ColorSystem.main)),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: ColorSystem.grey[300],
                          color: ColorSystem.main,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("${member.distance.toStringAsFixed(1)}km",
                          style: FontSystem.H4),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLabeledTrash() {
    // Access the labels data from the ViewModel
    final labels = viewModel.teamInfoState.monthlyData["2024-12"]?.labels;

    if (labels == null || labels.isEmpty) {
      return const Center(child: Text("라벨 데이터가 없습니다."));
    }

    // Determine the number of columns based on the number of labels
    int crossAxisCount = labels.length > 6
        ? 3
        : 2; // Example logic to switch between 2 and 3 columns

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text("팀원이 주운 쓰레기", style: FontSystem.H3),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent scrolling inside the grid
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                crossAxisCount, // Dynamic number of columns in the grid
            childAspectRatio: 1, // Aspect ratio for each item
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: labels.length,
          itemBuilder: (context, index) {
            final label = labels[index];
            final emoji =
                labelToEmoji[label.label] ?? ""; // Get emoji or default
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$emoji',
                    style: FontSystem.H2.copyWith(color: ColorSystem.main),
                  ),
                  Text(
                    '${label.count}개',
                    style: FontSystem.Sub2.copyWith(color: ColorSystem.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
