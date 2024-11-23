import 'package:flutter/material.dart';

class UserProgressBar extends StatefulWidget {
  final double progress; // 진행률 (0.0 ~ 1.0)
  final Color backgroundColor; // 배경 색상
  final Color progressColor; // 진행 색상
  final double height; // 바 높이
  final Duration animationDuration; // 애니메이션 지속 시간

  const UserProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF0F2A4F),
    this.height = 10.0,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  State<UserProgressBar> createState() => _UserProgressBarState();
}

class _UserProgressBarState extends State<UserProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(UserProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 전체 바 (배경)
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
        ),
        // 진행 바 (애니메이션)
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: MediaQuery.of(context).size.width * _animation.value,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.progressColor,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
            );
          },
        ),
      ],
    );
  }
}
