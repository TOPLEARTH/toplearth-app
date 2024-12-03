import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_recent.state.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';

class RecentPloggingScreen extends StatelessWidget {
  final MatchingGroupViewModel viewModel = Get.find<MatchingGroupViewModel>();

  RecentPloggingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('최근 플로깅 인증'),
        centerTitle: true,
      ),
      body: Obx(() {
        final ploggingList = viewModel.recentPloggingList.value.recentMatchingInfo;

        if (ploggingList.isEmpty) {
          return const Center(
            child: Text(
              "플로깅 기록이 없습니다.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.75, // Adjust height/width ratio
            ),
            itemCount: ploggingList.length,
            itemBuilder: (context, index) {
              final plogging = ploggingList[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the "report" page
                  Get.toNamed(AppRoutes.REPORT, arguments: plogging);
                },
                child: PloggingCard(plogging: plogging),
              );
            },
          ),
        );
      }),
    );
  }
}

class PloggingCard extends StatelessWidget {
  final PloggingRecentState plogging;

  const PloggingCard({Key? key, required this.plogging}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                plogging.ploggingImageList.isNotEmpty
                    ? plogging.ploggingImageList.first.imageUrl
                    : 'https://via.placeholder.com/150', // Fallback image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Information Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${plogging.distance.toStringAsFixed(1)}km",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  plogging.teamName,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "${plogging.startedAt.year}.${plogging.startedAt.month.toString().padLeft(2, '0')}.${plogging.startedAt.day.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "총 쓰레기: ${plogging.trashCnt}개",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
