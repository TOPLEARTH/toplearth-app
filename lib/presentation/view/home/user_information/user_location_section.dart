import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/domain/entity/global/region_ranking_state.dart';
import 'package:toplearth/presentation/view/widget/custom_model_viewer.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';

class HomeMapSwitcherView extends StatelessWidget {
  const HomeMapSwitcherView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.put(HomeViewModel());

    return Column(
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (viewModel.isLoading.value)
                    const Text(
                      '로딩 중...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF607D8B),
                      ),
                    )
                  else
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

class UserEarthView extends StatelessWidget {
  const UserEarthView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.find<HomeViewModel>();

    String getAnimationFile() {
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 10)
        return 'happy.glb';
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 5) return 'good.glb';
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 2) return 'soso.glb';
      if (viewModel.homeInfoState.ploggingMonthlyCount >= 1) return 'sad.glb';
      return 'good.glb';
    }

    String getAnimationName() {
      final count = viewModel.homeInfoState.ploggingMonthlyCount;

      if (count >= 10) return 'Animation.happy';
      if (count >= 5) return 'Animation.good';
      if (count >= 2) return 'Animation.soso';
      if (count >= 1) return 'Animation.sad';
      return 'Animation.anger';
    }

    return InkWell(
      child: Container(
        height: 350,
        width: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Obx(() => CustomModelViewer(
                  animationToPlay: getAnimationName(),
                  src: 'assets/animations/${getAnimationFile()}',
                  backgroundColor: Colors.white,
                  autoRotateDelay: 0,
                  autoRotate: true,
                )),
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.toNamed('/legacy'),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserMapView extends BaseWidget<HomeViewModel> {
  const UserMapView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() {
      final regionRankingInfo =
          controller.regionRankingInfoState.regionRankingInfo;

      if (regionRankingInfo.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // 컬러 매핑 생성 (랭킹 순서에 따라 색상 설정)
      final Map<String, Color> colorMap = _generateColorMap(regionRankingInfo);

      return FutureBuilder<String>(
        future: _loadAndModifySvg(
          'assets/images/seoul/seoul.svg',
          colorMap,
          context,
          regionRankingInfo,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return GestureDetector(
              onTapDown: (details) => _handleMapTap(details, regionRankingInfo),
              child: SvgPicture.string(
                snapshot.data!,
                height: 400,
                width: double.infinity,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading SVG'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  Future<String> _loadAndModifySvg(
    String assetPath,
    Map<String, Color> colorMap,
    BuildContext context,
    List<RegionRankingState> regionRankingInfo,
  ) async {
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

  void _handleMapTap(
      TapDownDetails details, List<RegionRankingState> regionRankingInfo) {
    // 클릭된 SVG ID에 해당하는 RegionId 탐색 (상세 구현 필요)
    final String tappedRegionId = _findRegionId(details);

    // RegionId에 매칭되는 데이터 가져오기
    final tappedRegion = regionRankingInfo
        .firstWhere((region) => region.regionId.toString() == tappedRegionId);

    // 모달 표시
    Get.dialog(
      AlertDialog(
        title: Text('${tappedRegion.regionName} 정보'),
        content: Text(
            '${tappedRegion.regionName}는 ${tappedRegion.score}점으로 ${tappedRegion.ranking}등이에요!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _generateColorMap(
      List<RegionRankingState> regionRankingInfo) {
    // Primary Color에서 랭킹에 따른 색상 선택
    final List<Color> gradientColors = [
      ColorSystem.primary[900]!, // 1등
      ColorSystem.primary[700]!, // 2등
      ColorSystem.primary[700]!, // 2등
      ColorSystem.primary[500]!, // 3등
      ColorSystem.primary[500]!, // 3등
      ColorSystem.primary[500]!, // 3등
      ColorSystem.primary[400]!, // 4등
      ColorSystem.primary[400]!, // 4등
      ColorSystem.primary[400]!, // 4등
      ColorSystem.primary[400]!, // 4등
      ColorSystem.primary[300]!, // 5등
      ColorSystem.primary[300]!, // 5등
      ColorSystem.primary[300]!, // 5등
      ColorSystem.primary[300]!, // 5등
      ColorSystem.primary[300]!, // 5등
      ColorSystem.primary[200]!, // 6등
      ColorSystem.primary[200]!, // 6등
      ColorSystem.primary[200]!, // 6등
      ColorSystem.primary[200]!, // 6등
      ColorSystem.primary[200]!, // 6등
      ColorSystem.primary[200]!, // 6등
    ];

    final Map<String, Color> colorMap = {};
    for (final region in regionRankingInfo) {
      final colorIndex = region.ranking - 1; // 랭킹 기반 색상 선택
      colorMap[region.regionId.toString()] =
          gradientColors[colorIndex < gradientColors.length ? colorIndex : 12];
    }
    return colorMap;
  }

  String _findRegionId(TapDownDetails details) {
    // SVG 좌표 기반으로 클릭된 RegionId 탐지 로직 구현 필요
    // 임시로 RegionId 1 반환
    return '1';
  }
}
