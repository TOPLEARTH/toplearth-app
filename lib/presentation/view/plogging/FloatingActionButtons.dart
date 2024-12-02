import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';

class FloatingActionButtons extends BaseWidget<PloggingViewModel> {
  const FloatingActionButtons({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'zoom_out_plogging_screen',
            onPressed: () => viewModel.toggleTrashBins(),
            backgroundColor: viewModel.showTrashBins.value
                ? ColorSystem.main
                : Colors.grey,
            child: Icon(viewModel.showTrashBins.value
                ? Icons.delete_outline
                : Icons.delete_outline_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: viewModel.isTracking.value
                ? () => viewModel.stopPlogging()
                : () => viewModel.startIndividualPlogging(),
            label: Text(viewModel.isTracking.value
                ? "Stop Plogging"
                : "Start Plogging"),
            icon:
            Icon(viewModel.isTracking.value ? Icons.stop : Icons.play_arrow),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'toggle_photo_markers',
            onPressed: () => viewModel.togglePhotoMarkers(),
            backgroundColor: Colors.orange,
            child: const Icon(Icons.visibility, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
