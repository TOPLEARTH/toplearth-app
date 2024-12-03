import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';

class PloggingLabelingScreen extends BaseWidget<PloggingViewModel> {
  final List<Map<String, dynamic>> ploggingImages;

  PloggingLabelingScreen({Key? key})
      : ploggingImages = Get.arguments['ploggingImages'] ?? [],
        super(key: key);

  // Map to store selected labels for each ploggingImageId
  final RxMap<int, String> selectedLabels = <int, String>{}.obs;

  final List<Map<String, String>> trashCategories = [
    {
      'label': '캔',
      'icon': 'assets/images/labeling/labeling_can_icon.png',
      'serverLabel': 'CAN'
    },
    {
      'label': '플라스틱 병',
      'icon': 'assets/images/labeling/labeling_plastic_icon.png',
      'serverLabel': 'PLASTIC'
    },
    {
      'label': '종이컵 및 종이',
      'icon': 'assets/images/labeling/labeling_paper_icon.png',
      'serverLabel': 'PAPER'
    },
    {
      'label': '유리병',
      'icon': 'assets/images/labeling/labeling_glass_icon.png',
      'serverLabel': 'GLASS'
    },
    {
      'label': '담배꽁초',
      'icon': 'assets/images/labeling/labeling_smoke_icon.png',
      'serverLabel': 'CIGARETTE'
    },
    {
      'label': '비닐봉지',
      'icon': 'assets/images/labeling/labeling_vinyl_icon.png',
      'serverLabel': 'PLASTIC_BAG'
    },
    {
      'label': '음식물 쓰레기',
      'icon': 'assets/images/labeling/labeling_food_icon.png',
      'serverLabel': 'FOOD_WASTE'
    },
    {
      'label': '일회용 용기',
      'icon': 'assets/images/labeling/labeling_disposable_icon.png',
      'serverLabel': 'GENERAL'
    },
  ];

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '쓰레기 라벨링',
          style: FontSystem.H3,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: ploggingImages.length,
                itemBuilder: (context, index) {
                  final item = ploggingImages[index];
                  return GestureDetector(
                    onTap: () => _showLabelingDialog(context, item),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16), // 둥근 모서리
                            child: Image.network(
                              item['imageUrl'],
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // 라벨링 완료된 이미지에 검은색 불투명 오버레이 및 아이콘 추가
                        Obx(() {
                          final isLabeled = selectedLabels
                              .containsKey(item['ploggingImageId']);
                          final label = selectedLabels[item['ploggingImageId']];
                          final icon = trashCategories.firstWhere(
                                  (category) =>
                              category['serverLabel'] == label)['icon'];

                          return isLabeled
                              ? Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    icon!,
                                    height: 48,
                                    width: 48,

                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '라벨링 완료',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : const SizedBox.shrink();
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
            RoundedRectangleTextButton(
              width: double.infinity,
              height: 58,
              backgroundColor: ColorSystem.main,
              onPressed: _submitLabels,
              text: '라벨링 완료',
            ),
          ],
        ),
      ),
    );
  }

  void _showLabelingDialog(BuildContext context, Map<String, dynamic> image) {
    final imageId = image['ploggingImageId'];
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                image['imageUrl'],
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                '어떤 쓰레기를 주었는지 알려줄래요?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildCategoryGrid(imageId),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(int imageId) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: trashCategories.length,
      itemBuilder: (context, index) {
        final category = trashCategories[index];
        final serverLabel = category['serverLabel'];
        return Obx(() {
          final isSelected = selectedLabels[imageId] == serverLabel;
          return GestureDetector(
            onTap: () {
              selectedLabels[imageId] = serverLabel!;
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    category['icon']!,
                    height: 48,
                    width: 48,
                    color: isSelected ? Colors.white : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _submitLabels() {
    if (selectedLabels.length != ploggingImages.length) {
      Get.snackbar('오류', '모든 이미지에 대해 라벨을 선택해주세요.');
      return;
    }

    final imageIds = selectedLabels.keys.toList();
    final labels = selectedLabels.values.toList();

    Get.toNamed(
      AppRoutes.PLOGGING_SHARE,
      arguments: {
        'imageIds': imageIds,
        'labels': labels,
      },
    );
  }
}
