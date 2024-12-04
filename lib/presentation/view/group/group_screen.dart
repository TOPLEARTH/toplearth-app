import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/TextToEmoji.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/entity/group/member_state.dart';
import 'package:toplearth/presentation/view_model/group/group_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/group_request_dialog.dart';
import 'package:toplearth/presentation/widget/image/svg_image_view.dart';

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
    return Obx(() {
      // teamInfoState.teamName이 초기화되지 않았으면 '그룹 설정하기' 화면 표시
      if (viewModel.teamInfoState.teamName == '' ||
          viewModel.teamInfoState.teamName == null) {
        print('teamId is null');
        return _buildNotJoinedView();
      }

      // 정상적으로 데이터를 로드한 경우
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGroupInfoSection(),
              const SizedBox(height: 16),
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
      );
    });
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

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: FontSystem.Sub2),
        const SizedBox(height: 4),
        Text(
          value ?? '정보 없음', // null 처리
          style: FontSystem.Sub2.copyWith(color: ColorSystem.grey),
        ),
      ],
    );
  }

  Widget _buildMemberList() {
    final members = viewModel.teamInfoState.teamMembers ?? []; // null 처리

    if (members.isEmpty) {
      return const SizedBox.shrink(); // 빈 상태 처리
    }

    return Card(
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
              ...members.map((member) => _buildMemberRow(member)).toList(),
            ],
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
          Expanded(
            child: Text(
              member.name,
              style: FontSystem.H4,
              maxLines: 1, // 한 줄만 표시
              overflow: TextOverflow.ellipsis, // 초과 부분은 ...로 표시
            ),
          ),
          const SizedBox(width: 8),
          if (member.role == 'LEADER')
            const SvgImageView(assetPath: 'assets/icons/leader_icon.svg'),
        ],
      ),
    );
  }

  Widget _buildCircularProgressBar() {
    final matchCnt = viewModel.teamInfoState.matchCnt ?? 0; // null 처리
    final winCnt = viewModel.teamInfoState.winCnt ?? 0; // null 처리

    double winRate = matchCnt > 0 ? (winCnt / matchCnt) : 0.0;
    double winRate100 = matchCnt > 0 ? (winCnt / matchCnt) * 100 : 0.0;

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
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(ColorSystem.main),
                  backgroundColor: ColorSystem.grey[300],
                ),
                Text("${winRate100.toStringAsFixed(1)}%", style: FontSystem.H3),
              ],
            ),
            const SizedBox(height: 47),
            Text(
              "$matchCnt개의 대결 중\n$winCnt경기를 이겼어요!",
              style: FontSystem.Sub1.copyWith(color: ColorSystem.main),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceList() {
    final currentMonthData = viewModel.currentMonthData;

    if (currentMonthData == null) {
      return const Center(child: Text("이번 달 데이터가 없습니다.")); // null 처리
    }

    final members = currentMonthData.members;

    if (members.isEmpty) {
      return const Center(child: Text("팀원 데이터가 없습니다."));
    }

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
            final progress =
                maxDistance > 0 ? member.distance / maxDistance : 0.0;
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
    // Access the labels data from the ViewModel with null safety
    final monthlyData = viewModel.teamInfoState.monthlyData?["2024-12"];
    final labels = monthlyData?.labels ?? [];

    if (labels.isEmpty) {
      return const Center(child: Text("라벨 데이터가 없습니다.")); // null 처리
    }

    final crossAxisCount = labels.length > 6 ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text("팀원이 주운 쓰레기", style: FontSystem.H3),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1,
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
                    emoji,
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

Widget _buildNotJoinedView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '그룹 대항전에 참가하기 위해서는\n그룹에 소속되어 있어야 해요!',
        style: FontSystem.H1.copyWith(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      Image.asset(
        'assets/images/earth_matching.png',
        width: 400,
        height: 400,
        fit: BoxFit.contain,
      ),
      const SizedBox(height: 24),
      RoundedRectangleTextButton(
        text: '그룹 설정하기',
        backgroundColor: ColorSystem.main,
        borderRadius: 24,
        textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
        onPressed: () {
          Get.dialog(
            const GroupRequestDialog(),
          );
        },
      ),
    ],
  );
}
