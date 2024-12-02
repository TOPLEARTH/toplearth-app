import 'package:flutter/material.dart';

class RoundedRectangleTextButton extends StatefulWidget {
  const RoundedRectangleTextButton({
    super.key,
    this.height = 50,
    this.width,
    required this.text,
    this.icon,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.onPressed,
    this.borderRadius = 8.0,
    this.iconSpacing = 8.0,
  });

  final double? width;
  final double height;
  final String text;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor; // 테두리 색상
  final double borderWidth; // 테두리 두께
  final Function()? onPressed;
  final double borderRadius;
  final double iconSpacing;

  @override
  State<RoundedRectangleTextButton> createState() =>
      _RoundedRectangleTextButtonState();
}

class _RoundedRectangleTextButtonState
    extends State<RoundedRectangleTextButton> {
  double _opacity = 1.0; // Default opacity

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _opacity = 0.8;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _opacity = 1.0;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width * 0.8,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.borderColor != null && widget.borderWidth > 0
                ? Border.all(
              color: widget.borderColor!,
              width: widget.borderWidth,
            )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                SizedBox(width: widget.iconSpacing),
              ],
              Text(
                widget.text,
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
