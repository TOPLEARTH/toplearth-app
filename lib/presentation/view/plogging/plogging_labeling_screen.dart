import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class PloggingLabelingScreen extends BaseWidget<PloggingViewModel> {
  final List<Map<String, dynamic>> ploggingImages;

  // 생성자에서 Get.arguments를 안전하게 처리
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
  buildView(BuildContext context) {
    print('PloggingImages: $ploggingImages');

    print('selectedLabels: $selectedLabels');
    return Scaffold(
      appBar: AppBar(
        title: const Text('쓰레기 라벨링'),
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
                    child: Container(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            item['imageUrl'],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final label =
                                selectedLabels[item['ploggingImageId']];
                            return Text(
                              label ?? '라벨 없음',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitLabels,
              child: const Text('라벨링 완료'),
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
                '쓰레기 카테고리를 선택해주세요',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildCategoryGrid(imageId)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(), // Close dialog
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
        final serverLabel =
            category['serverLabel']; // Safely fetch the serverLabel
        return Obx(() {
          final isSelected = selectedLabels[imageId] == serverLabel;
          return GestureDetector(
            onTap: () {
              print('Selected Label: $serverLabel');
              if (serverLabel != null) {
                selectedLabels[imageId] = serverLabel; // Avoid null assignment
              }
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
    Get.toNamed(AppRoutes.PLOGGING_SHARE);
    if (selectedLabels.length != ploggingImages.length) {
      Get.snackbar('오류', '모든 이미지에 대해 라벨을 선택해주세요.');
      return;
    }

    print('Selected Labels: $selectedLabels');

    final imageIds = selectedLabels.keys.toList();
    final labels = selectedLabels.values.toList();

    print('ImageIds: $imageIds');

    print('Labels: $labels');

    Get.toNamed(AppRoutes.PLOGGING_SHARE);

    // viewModel.labelingPloggingImages(imageIds, labels
    //  , s
    // ).then((result) {
    //   if (result.success) {
    //     Get.toNamed(AppRoutes.PLOGGING_SHARE);
    //   } else {
    //     Get.snackbar('오류', result.message ?? '라벨링 처리 중 문제가 발생했습니다.');
    //   }
    // });
  }
}
