import 'package:flutter/material.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/presentation/view_model/store/store_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';

class StoreScreen extends BaseScreen<StoreViewModel> {
  const StoreScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text(
        'Store Screen',
        style: FontSystem.H1,
      ),
    );
  }
}
