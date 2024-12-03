import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/team_member_activity_card.dart';

class RealTimeTeamActivitySection extends BaseWidget<RootViewModel> {
  @override
  Widget buildView(BuildContext context) {
    return Obx(() {
      // Bootstrap이 로드되지 않은 경우 로딩 표시
      if (!viewModel.isBootstrapLoaded.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // teamInfoState가 null일 경우 기본 상태 처리
      final teamInfoState = viewModel.teamInfoState.value;
      if (teamInfoState == null || teamInfoState.teamMembers == null || teamInfoState.teamMembers!.isEmpty) {
        return const Center(
          child: Text(
            '팀원이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      // 팀원 정보 렌더링
      return Column(
        children: teamInfoState.teamMembers!.map((member) {
          return TeamMemberActivityCard(
            name: member.name,
            distance: member.distance,
            isActive: member.isActive,
          );
        }).toList(),
      );
    });
  }
}

