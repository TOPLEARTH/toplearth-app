import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view/legacy/widget/animated_counter_text.dart';
import 'package:toplearth/presentation/view_model/legacy/legacy_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_back_app_bar.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

class LegacyScreen extends BaseScreen<LegacyViewModel> {
  const LegacyScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultBackAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildTotalTrashSection(),
          const SizedBox(height: 24),
          _buildTotalUsersSection(),
          _buildTrashChart(),
        ],
      ),
    );
  }

  Widget _buildTotalTrashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PngImageView(
          assetPath: 'assets/images/total_trash_bin.png',
          height: 150,
          width: 500,
        ),
        const SizedBox(height: 16),
        const Text(
          "지금까지 우리가 모은 쓰레기",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "우리의 행동이 지구를 바꾸고 있습니다!",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        AnimatedCounterText(
          endValue: viewModel.legacyInfoState.totalTrashCnt, // 목표 숫자
          suffix: ' 개',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "*2024년 11월 기준",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTotalUsersSection() {
    return Container(
      color: ColorSystem.main,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PngImageView(
            assetPath: 'assets/images/total_user_person.png',
            height: 150,
            width: 500,
          ),
          const SizedBox(height: 16),
          const Text(
            "지금까지 우리와 함께한 유저들",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "지구를 지키는 발걸음을 함께 내딛고 있어요.",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          AnimatedCounterText(
            endValue: viewModel.legacyInfoState.totalUserCnt, // 목표 숫자
            suffix: '명',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "*2024년 11월 기준",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTrashChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "함께 주운 다양한 쓰레기 종류들",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "당신이 실천한 발걸음으로 지구가 더 깨끗해집니다.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: 45,
                labelStyle: const TextStyle(fontSize: 12),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                interval: 5,
              ),
              series: <CartesianSeries>[
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: [
                    {
                      'category': '플라스틱',
                      'value': viewModel.legacyInfoState.trashInfo.plastic
                    },
                    {
                      'category': '음식물',
                      'value': viewModel.legacyInfoState.trashInfo.foodWaste
                    },
                    {
                      'category': '유리병',
                      'value': viewModel.legacyInfoState.trashInfo.glassBottle
                    },
                    {
                      'category': '담배꽁초',
                      'value': viewModel.legacyInfoState.trashInfo.cigaretteButt
                    },
                    {
                      'category': '종이',
                      'value': viewModel.legacyInfoState.trashInfo.paper
                    },
                    {
                      'category': '일회용기',
                      'value': viewModel
                          .legacyInfoState.trashInfo.disposableContainer
                    },
                    {
                      'category': '캔',
                      'value': viewModel.legacyInfoState.trashInfo.can
                    },
                    {
                      'category': '비닐',
                      'value': viewModel.legacyInfoState.trashInfo.plasticBag
                    },
                    {
                      'category': '기타',
                      'value': viewModel.legacyInfoState.trashInfo.others
                    },
                  ],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      data['category'] as String,
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['value'] as int,
                  animationDuration: 2000,
                  borderRadius: BorderRadius.circular(4),
                  // 그라데이션 색상 적용
                  onCreateRenderer:
                      (ChartSeries<Map<String, dynamic>, String> series) {
                    return GradientColumnSeriesRenderer();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "2024년 11월 기준",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Custom renderer for adding gradients
class GradientColumnSeriesRenderer
    extends ColumnSeriesRenderer<Map<String, dynamic>, String> {
  @override
  ColumnSegment<Map<String, dynamic>, String> createSegment() {
    return GradientColumnSegment();
  }
}

class GradientColumnSegment
    extends ColumnSegment<Map<String, dynamic>, String> {
  @override
  void onPaint(Canvas canvas) {
    final gradient = LinearGradient(
      colors: [Colors.blue, Colors.green],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
    fillPaint?.shader = gradient.createShader(segmentRect!.outerRect);
    super.onPaint(canvas);
  }
}
