import 'package:flutter/material.dart';

class SharedProgressBar extends StatelessWidget {
  final double teamAProgress;
  final double teamBProgress;
  final double height;
  final bool isFixed; // 추가된 변수

  const SharedProgressBar({
    Key? key,
    required this.teamAProgress,
    required this.teamBProgress,
    this.height = 30.0,
    this.isFixed = false, // 기본값은 고정되지 않음
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 고정 상태일 경우 50:50 비율로 설정
    final double fixedTeamAProgress = isFixed ? 0.5 : teamAProgress;
    final double fixedTeamBProgress = isFixed ? 0.5 : teamBProgress;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: [
          // Team A Progress
          Expanded(
            flex: (fixedTeamAProgress * 100).toInt(), // double 값을 int로 변환
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F2A4F), // Navy for Team A
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(height / 2),
                  right: isFixed
                      ? Radius.zero
                      : Radius.circular(height / 2), // Fixed 경우 오른쪽은 평평하게
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${(fixedTeamAProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          // Team B Progress
          Expanded(
            flex: (fixedTeamBProgress * 100).toInt(), // double 값을 int로 변환
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: isFixed
                      ? Radius.zero
                      : Radius.circular(height / 2), // Fixed 경우 왼쪽은 평평하게
                  right: Radius.circular(height / 2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${(fixedTeamBProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
