// naver_map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/test_code/plogging_view_model.dart';

class PloggingScreen extends BaseScreen<PloggingViewModel> {
  const PloggingScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(() => Text(
            viewModel.isTracking.value
                ? "Tracking: ${viewModel.ploggingTime.value.inSeconds}s"
                : "Plogging",
          )),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          NaverMap(
            onMapReady: viewModel.onMapReady,
          ),
          Positioned(
            right: 16,
            bottom: 150, // 바텀바 높이 + 여유 공간
            child: _buildFloatingActionButton(context),
          ),
        ],
      ),
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () => viewModel.moveToCurrentLocation(),
          backgroundColor: viewModel.isFollowingLocation.value
              ? ColorSystem.main
              : Colors.grey,
          child: const Icon(Icons.location_on),
        ),
        FloatingActionButton(
          onPressed: () => viewModel.toggleTrashBins(),
          backgroundColor:
              viewModel.showTrashBins.value ? ColorSystem.main : Colors.grey,
          child: Icon(viewModel.showTrashBins.value
              ? Icons.delete_outline
              : Icons.delete_outline_outlined),
        ),
        FloatingActionButton(
          heroTag: "add_marker",
          onPressed: () => viewModel.addMarkerAtCurrentLocation(),
          backgroundColor: ColorSystem.main,
          child: const Icon(Icons.add_location),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: viewModel.isTracking.value
              ? () => viewModel.stopPlogging()
              : () => viewModel.startPlogging(),
          label: Text(
              viewModel.isTracking.value ? "Stop Plogging" : "Start Plogging"),
          icon:
              Icon(viewModel.isTracking.value ? Icons.stop : Icons.play_arrow),
        ),
      ],
    );
  }
}
