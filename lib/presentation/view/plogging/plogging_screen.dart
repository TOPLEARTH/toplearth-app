import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view/plogging/DraggableSheet.dart';
import 'package:toplearth/presentation/view_model/plogging/naver_map_component.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';

class PloggingScreen extends BaseScreen<PloggingViewModel> {
  const PloggingScreen({super.key});

  /// Screenshot 사용 활성화
  @override
  bool get needsScreenshot => true;

  @override
  ScreenshotController getScreenshotController() {
    return viewModel.screenshotController;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar(
      isOnlyNeedCenterLogo: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return FutureBuilder<void>(
      future: viewModel.initializeCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('위치 정보를 불러오는 데 실패했습니다.'));
        } else {
          return Stack(
            children: [
              // Use NaverMapComponent here
              const NaverMapComponent(),
              Positioned(
                right: 16,
                bottom: 150,
                child: _buildFloatingActionButton(context),
              ),
              const DraggableSheet(),
            ],
          );
        }
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'zoom_out_plogging_screen',
          onPressed: () async {
            await viewModel.toggleTrashBins();
          },
          backgroundColor:
              viewModel.showTrashBins.value ? ColorSystem.main : Colors.grey,
          child: Icon(
            viewModel.showTrashBins.value ? Icons.delete : Icons.delete_outline,
          ),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'toggle_photo_markers',
          onPressed: () async {
            await viewModel.togglePhotoMarkers();
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.visibility, color: Colors.white),
        ),
      ],
    );
  }
}
