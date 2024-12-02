import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/presentation/view/matching/real_time_team_activity_section.dart';
import 'package:toplearth/presentation/view/matching/recent_plogging_view.dart';
import 'package:toplearth/presentation/view/root/build_plogging_view.dart';
import 'package:toplearth/presentation/view/root/matched_view.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/plogging/naver_map_component.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/group_request_dialog.dart';

class MatchingScreen extends BaseScreen<MatchingGroupViewModel> {
  const MatchingScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      final currentStatus = viewModel.matchingStatus.value;

      // Render different views based on the current matching status
      Widget statusView = _buildViewForStatus(currentStatus);

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 150), // 하단에 32px 패딩 추가
        child: Column(
          children: [
            statusView,
            // 네이버 지도 컴포넌트
            SizedBox(height: 24),
            // RecentPloggingView(),
            // const NaverMapComponent(height: 300),
          ],
        ),
      );
    });
  }

  Widget _buildViewForStatus(EMatchingStatus status) {
    print('MatchingScreen: _buildViewForStatus - status: $status');
    switch (status) {
      case EMatchingStatus.NOT_JOINED:
        return _buildNotJoinedView();
      case EMatchingStatus.DEFAULT:
        return _buildDefaultView();
      case EMatchingStatus.WAITING:
        return _buildWaitingView();
      case EMatchingStatus.MATCHED:
        return MatchedView();
      case EMatchingStatus.PLOGGING:
        return WidgetBuildPloggingView();
      case EMatchingStatus.FINISHED:
        return _buildDefaultView();
      default:
        return _buildDefaultView();
    }
  }

  /// NOTJOINED View
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

  /// DEFAULT View
  Widget _buildDefaultView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '얼쑤얼쑤팀은 현재\n플로깅을 쉬고 있어요!',
          style: FontSystem.H1.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        RoundedRectangleTextButton(
          onPressed: () {
            viewModel.requestRandomMatching();
            Get.snackbar('랜덤 매칭', '랜덤 매칭 요청이 실행되었습니다.');
          },
          text: '7시 플로깅 랜덤매칭 하기',
          icon: Image.asset(
            'assets/images/matching_dice_image.png',
            width: 36,
            height: 36,
          ),
          backgroundColor: Colors.white,
          textStyle: FontSystem.H3.copyWith(color: ColorSystem.main),
          borderRadius: 16.0,
          borderWidth: 0.7,
          borderColor: ColorSystem.main,
        ),
        const SizedBox(height: 16),
        RoundedRectangleTextButton(
          text: '7시 플로깅 지정매칭 하기',
          icon: Image.asset(
            'assets/images/matching_target_image.png',
            width: 36,
            height: 36,
          ),
          backgroundColor: Colors.white,
          textStyle: FontSystem.H3.copyWith(color: ColorSystem.main),
          borderRadius: 16.0,
          borderWidth: 0.7,
          borderColor: ColorSystem.main,
          onPressed: () {
            Get.snackbar('지정 매칭', '지정 매칭 요청이 실행되었습니다.');
          },
        ),
        const SizedBox(height: 16),
        RealTimeTeamActivitySection(),
      ],
    );
  }

  /// WAITING View
  Widget _buildWaitingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '얼쑤얼쑤팀은 현재\n7시 플로깅 매칭중이에요!',
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
            // GroupRequestDialog 다이얼로그 띄우기
            Get.dialog(
              const GroupRequestDialog(),
            );
          },
        ),
      ],
    );
  }

  /// PLOGGING VIEW

  /// FINISHED View
  Widget _buildFinishedView() {
    return Center(
      child: Text(
        '매칭이 종료되었습니다.',
        style: FontSystem.Sub2.copyWith(color: Colors.black),
      ),
    );
  }
}
