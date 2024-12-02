import 'package:flutter/material.dart';

// 팀원 활동 카드 위젯
class TeamMemberActivityCard extends StatelessWidget {
  final String name;
  final double progress;
  final bool isActive; // true면 초록색(활동 중), false면 빨간색(쉬는 중)
  final String statusText;

  const TeamMemberActivityCard({
    Key? key,
    required this.name,
    required this.progress,
    required this.isActive,
    required this.statusText,
  }) : super(key: key);

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
                    name,
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
                    color: isActive ? Colors.green : Colors.red,
                    size: 10,
                  ),
                ],
              ),
              // 진행률 또는 상태 텍스트
              Text(
                isActive ? '${(progress * 10).toStringAsFixed(1)}km' : statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 8),
            // 진행률 바
            UserProgressBar(
              progress: progress / 10,
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

// 메인 스크린
class TeamActivityScreen extends StatelessWidget {
  const TeamActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 더미 데이터
    final members = [
      {'name': '김무로', 'progress': 5.2, 'isActive': true, 'statusText': ''},
      {'name': '김신공', 'progress': 10.2, 'isActive': true, 'statusText': ''},
      {'name': '김동국', 'progress': 0.0, 'isActive': false, 'statusText': '현재 플로깅을 쉬고 있어요'},
      {'name': '김경희', 'progress': 0.0, 'isActive': false, 'statusText': '현재 플로깅을 쉬고 있어요'},
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 팀원 활동'),
        backgroundColor: const Color(0xFF0F2A4F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '실시간 팀원 활동',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            // 팀원 활동 카드 리스트
            ...members.map((member) {
              return TeamMemberActivityCard(
                name: member['name'] as String,
                progress: member['progress'] as double,
                isActive: member['isActive'] as bool,
                statusText: member['statusText'] as String,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
