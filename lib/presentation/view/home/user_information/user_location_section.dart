import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class HomeMapSwitcherView extends StatelessWidget {
  const HomeMapSwitcherView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.put(HomeViewModel());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => GestureDetector(
                onTap: () async {
                  await viewModel.fetchCurrentLocation();
                },
                child: Row(
                  children: [
                    Text(
                      viewModel.regionName.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF607D8B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.location_on, color: Color(0xFF607D8B)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: viewModel.toggleView,
              icon: Obx(
                () => Icon(
                  viewModel.showEarthView.value ? Icons.map : Icons.public,
                  color: const Color(0xFF607D8B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => Stack(
            alignment: Alignment.center,
            children: [
              if (viewModel.showEarthView.value)
                const UserEarthView()
              else
                GestureDetector(
                  onTap: viewModel.toggleModal,
                  child: UserMapView(),
                ),
              if (viewModel.showModal.value)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: viewModel.toggleModal,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      alignment: Alignment.center,
                      child: Text(
                        '${viewModel.regionName.value}는 현재\n서울시에서 1등이에요!',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// UserEarthView
class UserEarthView extends StatelessWidget {
  const UserEarthView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/legacy'); // Navigate to the Earth view
      },
      child: Container(
        height: 300,
        width: double.infinity,
        alignment: Alignment.center,
        child: const Text(
            '지구 뷰 Placeholder'), // Replace with your actual Earth view
      ),
    );
  }
}

class UserMapView extends BaseWidget<HomeViewModel> {
  const UserMapView({super.key});

  @override
  buildView(BuildContext context) {
    // 기본 색상 매핑 (1-25)
    const Map<String, Color> colorMap = {
      '1': Color(0xFFEBF3FA),
      '2': Color(0xFFD9E8F6),
      '3': Color(0xFFAFCCEC),
      '4': Color(0xFF8AB0D9),
      '5': Color(0xFF6A94C4),
      '6': Color(0xFF4F7AAE),
      '7': Color(0xFF3A6495),
      '8': Color(0xFF2A4F7A),
      '9': Color(0xFF1A3A5F),
      '10': Color(0xFF0F2644),
      '11': Color(0xFF0A1A2E),
      '12': Color(0xFF050D17),
      '13': Color(0xFFEBF3FA),
      '14': Color(0xFFD9E8F6),
      '15': Color(0xFFAFCCEC),
      '16': Color(0xFF8AB0D9),
      '17': Color(0xFF6A94C4),
      '18': Color(0xFF4F7AAE),
      '19': Color(0xFF3A6495),
      '20': Color(0xFF2A4F7A),
      '21': Color(0xFF1A3A5F),
      '22': Color(0xFF0F2644),
      '23': Color(0xFF0A1A2E),
      '24': Color(0xFF050D17),
      '25': Color(0xFFEBF3FA),
    };

    return Obx(() {
      // viewModel.regionId를 기준으로 붉은색으로 업데이트
      final regionId = controller.regionId.value.toString();
      final updatedColorMap = Map<String, Color>.from(colorMap)
        ..[regionId] = const Color(0xFFFF0000); // 특정 지역을 붉은색으로 설정

      return FutureBuilder<String>(
        future: _loadAndModifySvg(
            'assets/images/seoul/seoul.svg', updatedColorMap, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SvgPicture.string(
              snapshot.data!,
              height: 300,
              width: double.infinity,
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading SVG'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  Future<String> _loadAndModifySvg(String assetPath,
      Map<String, Color> colorMap, BuildContext context) async {
    // SVG 파일 문자열 읽기
    final svgString =
        await DefaultAssetBundle.of(context).loadString(assetPath);

    // 색상 매핑 적용
    var modifiedSvg = svgString;
    colorMap.forEach((id, color) {
      final colorHex =
          color.value.toRadixString(16).substring(2); // Color를 HEX로 변환
      final regex =
          RegExp(r'id="' + id + r'"[^>]*fill="[^"]*"', caseSensitive: false);
      modifiedSvg = modifiedSvg.replaceAllMapped(regex, (match) {
        return match
            .group(0)!
            .replaceFirst(RegExp(r'fill="[^"]*"'), 'fill="#$colorHex"');
      });
    });

    return modifiedSvg;
  }
}
