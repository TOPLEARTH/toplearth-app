import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class PloggingPathPainter extends CustomPainter {
  final List<NLatLng> coordinates;
  final List<NLatLng> markerPoints;
  final ui.Image markerImage; // SVG에서 변환된 이미지

  PloggingPathPainter(
    this.coordinates, {
    this.markerPoints = const [],
    required this.markerImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 배경 그리기
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    if (coordinates.isEmpty) return;

    // 경로 그리기
    final pathPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final points = _normalizePoints(coordinates, size);

    path.moveTo(points.first.dx, points.first.dy);
    for (var point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, pathPaint);

    // 마커 이미지 그리기
    final normalizedMarkers = _normalizePoints(markerPoints, size);
    for (var point in normalizedMarkers) {
      // 이미지 크기 설정
      final imageSize = 24.0;
      final src = Rect.fromLTWH(
          0, 0, markerImage.width.toDouble(), markerImage.height.toDouble());
      final dst = Rect.fromCenter(
        center: point,
        width: imageSize,
        height: imageSize,
      );

      canvas.drawImageRect(markerImage, src, dst, Paint());
    }
  }

  List<Offset> _normalizePoints(List<NLatLng> coords, Size size) {
    if (coords.isEmpty) return [];

    double minLat = coordinates.first.latitude;
    double maxLat = minLat;
    double minLng = coordinates.first.longitude;
    double maxLng = minLng;

    for (var coord in coordinates) {
      minLat = math.min(minLat, coord.latitude);
      maxLat = math.max(maxLat, coord.latitude);
      minLng = math.min(minLng, coord.longitude);
      maxLng = math.max(maxLng, coord.longitude);
    }

    return coords.map((coord) {
      final x = ((coord.longitude - minLng) / (maxLng - minLng)) * size.width;
      final y = ((coord.latitude - minLat) / (maxLat - minLat)) * size.height;
      return Offset(x, y);
    }).toList();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
