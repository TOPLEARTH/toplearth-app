import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class RootScreen extends GetView<RootViewModel> {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorSystem.white,
      body: Center(
        child: Text(
          'Toplearth Root Screen',
          style: FontSystem.H6,
        ),
      ),
    );
  }
}
