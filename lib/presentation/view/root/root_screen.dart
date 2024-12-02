import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view/group/group_screen.dart';
import 'package:toplearth/presentation/view/home/home_screen.dart';
import 'package:toplearth/presentation/view/matching/matching_screen.dart';
import 'package:toplearth/presentation/view/my_page/my_page_screen.dart';
import 'package:toplearth/presentation/view/root/widget/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:toplearth/presentation/view/store/store_screen.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
import 'package:toplearth/presentation/view/plogging/plogging_screen.dart';

class RootScreen extends BaseScreen<RootViewModel> {
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
          PloggingScreen(),
          // StoreScreen(),
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
