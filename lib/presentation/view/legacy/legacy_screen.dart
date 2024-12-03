import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
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
    int getMaxValue() {
      final trashInfo = viewModel.legacyInfoState.trashInfo;
      return [
        trashInfo.plastic,
        trashInfo.foodWaste,
        trashInfo.glassBottle,
        trashInfo.cigaretteButt,
        trashInfo.paper,
        trashInfo.disposableContainer,
        trashInfo.can,
        trashInfo.plasticBag,
        trashInfo.others,
      ].reduce((max, value) => max > value ? max : value);
    }

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
            "🌍 당신이 실천한 발걸음으로 지구가 더 깨끗해집니다.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: getMaxValue() * 1.2,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = [
                          '플라스틱',
                          '음식물',
                          '유리병',
                          '담배꽁초',
                          '종이',
                          '일회용기',
                          '캔',
                          '비닐',
                          '기타'
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle: -0.8,
                            child: Text(
                              titles[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroupData(
                      0, viewModel.legacyInfoState.trashInfo.plastic),
                  _makeGroupData(
                      1, viewModel.legacyInfoState.trashInfo.foodWaste),
                  _makeGroupData(
                      2, viewModel.legacyInfoState.trashInfo.glassBottle),
                  _makeGroupData(
                      3, viewModel.legacyInfoState.trashInfo.cigaretteButt),
                  _makeGroupData(4, viewModel.legacyInfoState.trashInfo.paper),
                  _makeGroupData(5,
                      viewModel.legacyInfoState.trashInfo.disposableContainer),
                  _makeGroupData(6, viewModel.legacyInfoState.trashInfo.can),
                  _makeGroupData(
                      7, viewModel.legacyInfoState.trashInfo.plasticBag),
                  _makeGroupData(8, viewModel.legacyInfoState.trashInfo.others),
                ],
              ),
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

  BarChartGroupData _makeGroupData(int x, int y) {
    // double을 int로 변경
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(), // int를 double로 변환
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
