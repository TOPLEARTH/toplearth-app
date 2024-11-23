import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';
import 'package:toplearth/presentation/widget/image/svg_image_view.dart';

class DefaultBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Optional title
  final VoidCallback? onBackPressed; // Optional custom back action
  final List<Widget>? actions; // Optional actions in the AppBar

  const DefaultBackAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
  });

  // Default paths for logo and back icon
  static const String _defaultLogoPath = 'assets/images/toplearth_text_logo.png';
  static const String _defaultBackIconPath = 'assets/icons/arrow_back.svg';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 0, // Remove shadow
      automaticallyImplyLeading: false, // Avoid default back button
      titleSpacing: 0, // Align title and leading icon
      leading: IconButton(
        onPressed: onBackPressed ?? Get.back, // Default to Get.back()
        splashRadius: 24,
        icon: SvgImageView(
          assetPath: _defaultBackIconPath,
        ),
      ),
      title: title != null
          ? Text(
        title!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      )
          : const Center(
        child: Padding(
          padding: EdgeInsets.only(right: 50.0), // Adjust spacing for balance
          child: PngImageView(
            assetPath: _defaultLogoPath,
            height: 65, // Unified height with DefaultAppBar
          ),
        ),
      ),
      centerTitle: title == null, // Center only if no title
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0); // Unified height
}
