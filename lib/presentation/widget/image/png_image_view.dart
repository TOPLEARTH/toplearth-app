import 'package:flutter/material.dart';

class PngImageView extends StatelessWidget {
  const PngImageView({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: color == null
          ? Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      )
          : ColorFiltered(
        colorFilter: ColorFilter.mode(
          color!,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }
}
