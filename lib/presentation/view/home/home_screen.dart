import 'package:flutter/material.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view/home/user_information/user_information_view.dart';
import 'package:toplearth/presentation/view/home/user_information/user_location_section.dart';
import 'package:toplearth/presentation/view_model/home/home_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Color get unSafeAreaColor => ColorSystem.blue;

  @override
  bool get setTopOuterSafeArea => true;

  @override
  bool get setBottomOuterSafeArea => false;

  @override
  bool get extendBodyBehindAppBar => false; // SafeArea를 넘지 않도록 설정

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    // final WebSocketController socketController = Get.put(WebSocketController());
    // socketController.connectToWebSocket();
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          HomeUserInfoView(),
          HomeMapSwitcherView(),
        ],
      ),
    );
  }
}
