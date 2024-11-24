import 'package:flutter/material.dart';
import 'package:toplearth/MessagePage.dart';
import 'package:toplearth/test_code/NaverMapScreen.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/local_push_notifications.dart';
import 'package:get/get.dart';
import 'package:toplearth/presentation/view/group/group_screen.dart';
import 'package:toplearth/presentation/view/home/home_screen.dart';
import 'package:toplearth/presentation/view/matching/matching_screen.dart';
import 'package:toplearth/presentation/view/my_page/my_page_screen.dart';
import 'package:toplearth/presentation/view/root/widget/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:toplearth/presentation/view/store/store_screen.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class RootScreen extends BaseScreen<RootViewModel>{
  const RootScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Obx(
      () => IndexedStack(
        index: viewModel.selectedIndex,
        children: const [
          MyPageScreen(),
          MatchingScreen(),
          HomeScreen(),
          StoreScreen(),
          GroupScreen(),
        ],
      ),
    );
  }

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  Widget? buildBottomNavigationBar(BuildContext context) =>
      const CustomBottomNavigationBar();
}