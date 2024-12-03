import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/app/utility/hour_util.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/presentation/view/home/user_information/user_earth_view.dart';
import 'package:toplearth/presentation/view/matching/matching_widget/matched_view.dart';
import 'package:toplearth/presentation/view/matching/real_time_team_activity_section.dart';
import 'package:toplearth/presentation/view/matching/widget/matching_group_recent_plogging_widget.dart';
import 'package:toplearth/presentation/view/root/build_plogging_view.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/dialog/group_request_dialog.dart';

import 'widget/plogging_preview_widget.dart';

class MatchingScreen extends BaseScreen<MatchingGroupViewModel> {
  const MatchingScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar(isOnlyNeedCenterLogo: true);
  }

  @override
  Widget buildBody(BuildContext context) {
    final rootViewModel = Get.find<RootViewModel>();

    return Obx(() {
      final teamId = rootViewModel.teamInfoState.value.teamId ?? 0;

      print('sibal ${viewModel.teamId}');

      if (teamId == 0) {
        return _buildNotJoinedView();
      }

      return Scaffold(
        resizeToAvoidBottomInset: true, // 키보드가 올라오면 화면 조정
        body: SingleChildScrollView(
          child: Obx(() {
            final currentStatus = viewModel.matchingStatus.value;
            Widget statusView = _buildViewForStatus(currentStatus);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  statusView,
                  const SizedBox(height: 24),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  /// 현재 한국시간 기반으로 다음 시간 계산
  int getNextHour() {
    // 한국 시간으로 초기화
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));

    // 현재 시간이 몇 분인지 확인
    if (now.minute > 0) {
      return (now.hour + 1) % 24; // 다음 시간으로 넘어감
    }
    return now.hour; // 현재 정각 시간 유지
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
    final nextHour = getNextHour();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${viewModel.teamInfoState.value.teamName}팀은 현재\n플로깅을 쉬고 있어요!',
            style: FontSystem.H1.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          RoundedRectangleTextButton(
            onPressed: () {
              viewModel.requestRandomMatching();
              // Get.snackbar('랜덤 매칭', '랜덤 매칭 요청이 실행되었습니다.');
            },
            text: '$nextHour시 플로깅 랜덤매칭 하기',
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
            text: '$nextHour시 플로깅 지정매칭 하기',
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
              // Get.snackbar('지정 매칭', '지정 매칭 요청이 실행되었습니다.');
            },
          ),
          const SizedBox(height: 16),
          RoundedRectangleTextButton(
            text: '지금 플로깅 혼자하러 가기',
            icon: Image.asset(
              'assets/images/matching_plogging_image.png',
              width: 36,
              height: 36,
            ),
            backgroundColor: Colors.white,
            textStyle: FontSystem.H3.copyWith(color: ColorSystem.main),
            borderRadius: 16.0,
            borderWidth: 0.7,
            borderColor: ColorSystem.main,
            onPressed: () {
              Get.toNamed(AppRoutes.PLOGGING);
            },
          ),
          const SizedBox(height: 16),
          RealTimeTeamActivitySection(),
          const PreviewPloggingMap(),
          const RecentPloggingPreview(),
        ],
      ),
    );
  }
}

final int nextHour = getNextHour();

/// WAITING View
/// WAITING View
class _buildWaitingView extends BaseWidget<MatchingGroupViewModel> {
  @override
  Widget buildView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${viewModel.teamInfoState.value.teamName}팀은 현재\n $nextHour시 플로깅 매칭중이에요!',
          style: FontSystem.H1.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        UserEarthView(),
        const SizedBox(height: 24),
        Text(
          '매 시 정각에 플로깅 대결 매칭이 시작합니다!\n쓰레기 봉투를 준비해 주세요!',
          style: FontSystem.H3.copyWith(
            color: ColorSystem.main,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
