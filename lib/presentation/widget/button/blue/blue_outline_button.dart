import 'package:flutter/material.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/presentation/widget/button/common/base_outline_button.dart';

class BlueOutlineButton extends BaseOutlineButton {
  const BlueOutlineButton({
    super.key,
    required super.width,
    required super.height,
    required super.content,
    required super.onPressed,
  });

  @override
  Color get borderColor => ColorSystem.blue.shade400;
}
