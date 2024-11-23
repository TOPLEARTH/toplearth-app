import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  const CustomBottomNavigationItem({
    super.key,
    required this.isActive,
    required this.assetPath,
  });

  final bool isActive;
  final String assetPath;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 2),
          height: 4,
          width: isActive ? 20 : 0,
          decoration: const BoxDecoration(
            color: Color(0xFF81B4FF),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        SvgPicture.asset(
          assetPath,
          height: 36,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
