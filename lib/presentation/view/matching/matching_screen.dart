import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/type/e_group_status.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

class MatchingScreen extends BaseScreen<MatchingGroupViewModel> {
  const MatchingScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // Apply common padding here
      child: Obx(() {
        // Observe the current group status
        final groupStatus = viewModel.groupStatus.value;

        switch (groupStatus) {
          case EGroupStatus.notJoined:
            return _buildNotJoinedUI(context);
          case EGroupStatus.joined:
            return _buildJoinedUI(context);
          case EGroupStatus.matching:
            return _buildMatchingUI(context);
          case EGroupStatus.matched:
            return _buildMatchedUI(context);
          case EGroupStatus.plogging:
            return _buildPloggingUI(context);
        }
      }),
    );
  }


  Widget _buildNotJoinedUI(BuildContext context) {
    return Column(
      children: [
        const Text(
          '그룹 대항전에 참가하기 위해서는\n그룹에 소속되어 있어야 해요!',
          style: FontSystem.H2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        const PngImageView(
          assetPath: 'assets/images/earth_view.png',
          height: 300,
        ),
        const SizedBox(height: 120),
        RoundedRectangleTextButton(
          borderRadius: 20,
          width: double.infinity,
          backgroundColor: ColorSystem.main,
          text: '그룹 설정하기',
          onPressed: () {
            // Trigger group setup dialog
            Get.snackbar('Info', '그룹 설정을 시작하세요!');
          },
        ),
      ],
    );
  }

  Widget _buildJoinedUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '열쑤얼쑤팀은 현재\n플로깅을 쉬고 있어요!',
          style: FontSystem.H2.copyWith(color: ColorSystem.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        RoundedRectangleTextButton(
          text: '7시 플로깅 랜덤매칭 하기',
          backgroundColor: ColorSystem.sub,
          textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
          onPressed: () {
            viewModel.simulateStatusChange(EGroupStatus.matching);
          },
        ),
        RoundedRectangleTextButton(
          text: '7시 플로깅 지정매칭 하기',
          backgroundColor: ColorSystem.sub,
          textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMatchingUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const PngImageView(
          assetPath: 'assets/images/matching_earth.png',
          height: 300,
        ),
        const SizedBox(height: 16),
        RoundedRectangleTextButton(
          text: '플로깅 하러 가기',
          backgroundColor: ColorSystem.main,
          textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
          onPressed: () {
            viewModel.simulateStatusChange(EGroupStatus.plogging);
          },
        ),
      ],
    );
  }

  Widget _buildMatchedUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '열쑤얼쑤 VS 디지유\n열심히 플로깅 중이에요!',
          style: FontSystem.H2.copyWith(color: ColorSystem.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          '실시간 팀원 활동',
          style: FontSystem.Sub1.copyWith(color: ColorSystem.black),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 4, // Example data
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(
                  '김유진',
                  style: FontSystem.Sub2.copyWith(color: ColorSystem.black),
                ),
                subtitle: Text(
                  '${(5.0 * index).toStringAsFixed(1)}km',
                  style: FontSystem.Sub2,
                ),
              );
            },
          ),
        ),
        RoundedRectangleTextButton(
          text: '플로깅 하러 가기',
          backgroundColor: ColorSystem.main,
          textStyle: FontSystem.Sub2.copyWith(color: Colors.white),
          onPressed: () {
            viewModel.simulateStatusChange(EGroupStatus.plogging);
          },
        ),
      ],
    );
  }

  Widget _buildPloggingUI(BuildContext context) {
    return Column(
      children: [
        Text(
          '열쑤얼쑤팀 플로깅 중!',
          style: FontSystem.H2.copyWith(color: ColorSystem.black),
        ),
        // Add other relevant widgets for plogging
      ],
    );
  }
}
