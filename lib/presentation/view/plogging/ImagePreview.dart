import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class ImagePreview extends BaseWidget<PloggingViewModel> {
  const ImagePreview({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() {
      if (viewModel.selectedImage.value != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            viewModel.selectedImage.value!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_gallery_image.png',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  "쓰레기 사진을 찍어주세요!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
