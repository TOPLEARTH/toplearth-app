import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/widget/image/svg_image_view.dart';

class CustomBottomNavigationBar extends BaseWidget<RootViewModel> {
  const CustomBottomNavigationBar({super.key});

  Widget buildView(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)), // 모서리 둥글게 설정
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: _buildItemViews(),
      ),
    );
  }




  List<Widget> _buildItemViews() {
    // Names for bottom navigation items
    const List<String> bottomBarName = [
      'MY',
      'VS',
      '홈',
      '스토어',
      '그룹',
    ];

    // Asset paths for inactive and active states
    const List<String> inActiveAssetPath = [
      "assets/icons/bottom_navigation/my_inactive.svg",
      "assets/icons/bottom_navigation/vs_inactive.svg",
      "assets/icons/bottom_navigation/home_inactive.svg",
      "assets/icons/bottom_navigation/store_inactive.svg",
      "assets/icons/bottom_navigation/group_inactive.svg",
    ];

    const List<String> activeAssetPath = [
      "assets/icons/bottom_navigation/my_active.svg",
      "assets/icons/bottom_navigation/vs_active.svg",
      "assets/icons/bottom_navigation/home_active.svg",
      "assets/icons/bottom_navigation/store_active.svg",
      "assets/icons/bottom_navigation/group_active.svg",
    ];

    return List.generate(
      bottomBarName.length,
          (index) => Expanded(
        child: GestureDetector(
          onTap: () {
            viewModel.changeIndex(index);
          },
          child: Obx(
                () {
              bool isActive = viewModel.selectedIndex == index;
              String assetPath = isActive
                  ? activeAssetPath[index]
                  : inActiveAssetPath[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgImageView(
                    assetPath: assetPath,
                    width: 32, // Icon size
                    height: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bottomBarName[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? const Color(0xFF0F2A4F) // Active color
                          : const Color(0xFF9E9E9E), // Inactive color
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


// @override
// Widget buildView(BuildContext context) {
//   return Container(
//     height: 88,
//     margin: EdgeInsets.only(
//       left: 16,
//       right: 16,
//       bottom: GetPlatform.isAndroid ? 20 : 32,
//     ),
//     decoration: const BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//     ),
//     child: Row(
//       children: _buildItemViews(),
//     ),
//   );
// }