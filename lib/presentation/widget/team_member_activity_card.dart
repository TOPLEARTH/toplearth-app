import 'dart:async';

import 'package:flutter/material.dart';

// 팀원 활동 카드 위젯
class TeamMemberActivityCard extends StatefulWidget {
  final String name;
  final double distance; // 초기 거리
  final bool isActive;
  final bool isPlogging; // 플로깅 여부 추가 (기본값: false)

  const TeamMemberActivityCard({
    Key? key,
    required this.name,
    required this.distance, // 초기 거리
    required this.isActive,
    this.isPlogging = false, // 기본값을 false로 설정
  }) : super(key: key);

  @override
  _TeamMemberActivityCardState createState() => _TeamMemberActivityCardState();
}

class _TeamMemberActivityCardState extends State<TeamMemberActivityCard> {
  double progress = 0.0; // 진행률 (0.0 ~ 1.0)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isPlogging) {
      startProgressBar();
    }
  }

  void startProgressBar() {
    // name이 '홍규진'이면 1초에 1%, 그렇지 않으면 3초에 1%
    final duration = widget.name == '홍규진'
        ? const Duration(seconds: 1)
        : const Duration(seconds: 3);

    _timer = Timer.periodic(duration, (_) {
      if (mounted) {
        setState(() {
          progress += 0.01; // 1%씩 증가
          if (progress >= 1.0) {
            _timer?.cancel(); // 최대값 도달 시 타이머 종료
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A4F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 팀원 이름
              Row(
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 상태 점
                  Icon(
                    Icons.circle,
                    color: widget.isActive ? Colors.green : Colors.red,
                    size: 10,
                  ),
                ],
              ),
              // 거리 또는 상태 텍스트
              Text(
                widget.isActive
                    ? '${(widget.distance + progress * 10).toStringAsFixed(1)}km'
                    : '현재 플로깅을 쉬고 있어요',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (widget.isActive && widget.isPlogging) ...[
            const SizedBox(height: 8),
            // 진행률 바
            UserProgressBar(
              progress: progress.clamp(0.0, 1.0), // 진행률 제한 (0.0 ~ 1.0)
              backgroundColor: const Color(0xFF203759),
              progressColor: Colors.green,
              height: 8,
            ),
          ],
        ],
      ),
    );
  }
}

// 진행률 바 위젯
class UserProgressBar extends StatelessWidget {
  final double progress; // 진행률 (0.0 ~ 1.0)
  final Color backgroundColor;
  final Color progressColor;
  final double height;

  const UserProgressBar({
    Key? key,
    required this.progress,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.green,
    this.height = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 바
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        // 진행 바
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ),
      ],
    );
  }
}
