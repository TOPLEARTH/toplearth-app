import 'package:flutter/material.dart';

class SharedProgressBar extends StatelessWidget {
  final double teamAProgress;
  final double teamBProgress;
  final double height;

  const SharedProgressBar({
    Key? key,
    required this.teamAProgress,
    required this.teamBProgress,
    this.height = 30.0, // Increased height for better visibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            flex: (teamAProgress * 100).toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F2A4F), // Navy for Team A
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(height / 2),
                  right: Radius.circular(height / 2), // Rounded for both sides
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${(teamAProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          // Team B Progress
          Expanded(
            flex: (teamBProgress * 100).toInt(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(height / 2), // Rounded for both sides
                  right: Radius.circular(height / 2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${(teamBProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
