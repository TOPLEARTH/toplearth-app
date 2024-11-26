import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
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
}
