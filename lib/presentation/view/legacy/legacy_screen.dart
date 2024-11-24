import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_back_app_bar.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';

class LegacyScreen extends BaseScreen<RootViewModel> {
  const LegacyScreen({super.key});

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return const DefaultBackAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTrashChartSection(context),
          _buildTotalTrashSection(context),
          const SizedBox(height: 24),
          _buildTotalUsersSection(context),
        ],
      ),
    );
  }

  Widget _buildTotalTrashSection(BuildContext context) {
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
          "우리의 행동이 지구를 바꾸고 있습니다.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const Text(
          "000,000 개",
          style: TextStyle(
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

  Widget _buildTotalUsersSection(BuildContext context) {
    return Container(
      color: ColorSystem.main,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PngImageView(
            assetPath: 'assets/images/total_user_person.png',
            height: 150,
            width: 500,
          ),
          SizedBox(height: 16),
          Text(
            "지금까지 우리와 함께한 유저들",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "지구를 지키는 발걸음을 함께 내딛고 있어요.",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          SizedBox(height: 16),
          Text(
            "0,000명",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "*2024년 11월 기준",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTrashChartSection(BuildContext context) {
    final List<TrashCategory> chartData = [
      TrashCategory('플라스틱', 30),
      TrashCategory('캔', 20),
      TrashCategory('종이', 50),
      TrashCategory('유리', 40),
      TrashCategory('기타', 10),
    ];

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
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries>[
              ColumnSeries<TrashCategory, String>(
                dataSource: chartData,
                xValueMapper: (TrashCategory data, _) => data.category,
                yValueMapper: (TrashCategory data, _) => data.value,
                animationDuration: 2000,
                onCreateRenderer: (ChartSeries<TrashCategory, String> series) {
                  return CustomColumnSeriesRenderer();
                },
              ),
            ],
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

class TrashCategory {
  final String category;
  final int value;

  TrashCategory(this.category, this.value);
}

// Custom renderer for adding gradients
class CustomColumnSeriesRenderer extends ColumnSeriesRenderer<TrashCategory, String> {
  @override
  ColumnSegment<TrashCategory, String> createSegment() {
    return GradientColumnSegment();
  }
}

class GradientColumnSegment extends ColumnSegment<TrashCategory, String> {
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
