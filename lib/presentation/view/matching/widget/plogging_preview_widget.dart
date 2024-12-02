// preview_plogging_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class PreviewPloggingMap extends BaseWidget<PloggingViewModel> {
  const PreviewPloggingMap({super.key});
  @override
  Widget buildView(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            NaverMap(
              options: const NaverMapViewOptions(
                scrollGesturesEnable: false,
                stopGesturesEnable: false,
                rotationGesturesEnable: false,
                tiltGesturesEnable: false,
              ),
              onMapReady: viewModel.onMapReady,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.touch_app,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
