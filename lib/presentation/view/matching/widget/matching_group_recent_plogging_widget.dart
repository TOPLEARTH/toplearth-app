import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/domain/entity/plogging/plogging_image_state.dart';
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';

import '../../../../domain/entity/plogging/plogging_recent.state.dart';

class RecentPloggingPreview extends BaseWidget<MatchingGroupViewModel> {
  const RecentPloggingPreview({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 플로깅 인증',
                  style: FontSystem.H1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: FontSystem.H3.copyWith(
                          color: ColorSystem.greySub,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: ColorSystem.greySub,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (viewModel.recentPloggingList.value.recentMatchingInfo.isEmpty)
              _buildEmptyState()
            else
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel
                      .recentPloggingList.value.recentMatchingInfo.length,
                  itemBuilder: (context, index) {
                    final plogging = viewModel
                        .recentPloggingList.value.recentMatchingInfo[index];
                    return _buildPloggingCard(plogging);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: ColorSystem.main,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '아직 플로깅 기록이 없어요',
          style: FontSystem.H1.copyWith(
            color: ColorSystem.greySub,
          ),
        ),
      ),
    );
  }

  Widget _buildPloggingCard(PloggingRecentState plogging) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          color: ColorSystem.white,
          borderRadius: BorderRadius.circular(12),
          //1px 검정 선으로 테두리 긋기
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (plogging.ploggingImageList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "플로깅 사진이 없습니다.",
                style: FontSystem.Sub3.copyWith(
                  color: ColorSystem.black,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  plogging.ploggingImageList.first.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            '${plogging.distance.toStringAsFixed(1)}KM',
            style: FontSystem.Sub3.copyWith(
              color: ColorSystem.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            plogging.teamName,
            style: FontSystem.Sub2.copyWith(
              color: ColorSystem.black,
            ),
          ),
          Text(
            _formatDateTime(plogging.endedAt),
            style: FontSystem.Sub2.copyWith(
              color: ColorSystem.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    String second = date.second.toString().padLeft(2, '0');

    return '$month월 $day일 $hour:$minute:$second';
  }

  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일';
  }

  Widget _buildPloggingImages(List<PloggingImageState> images) {
    if (images.isEmpty) {
      return const Text("플로깅 기록이 없습니다.");
    }

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                images[index].imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
