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
      if (!viewModel.isBootstrapLoaded.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final teamInfoState = viewModel.teamInfoState.value;

      if (teamInfoState.teamMembers!.isEmpty) {
        return Center(
          child: Text(
            '팀원이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return Column(
        children: teamInfoState.teamMembers!.map((member) {
          return TeamMemberActivityCard(
            name: member.name,
            progress: 5.2,
            isActive: true,
            statusText: '',
          );
        }).toList(),
      );
    });
  }

}
