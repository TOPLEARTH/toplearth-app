import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapHelper {
  final List<NMarker> trashBinMarkers = []; // Trash Bin Marker 리스트
  final List<NMarker> cleanMarkers = [];   // Clean Marker 리스트
  late NaverMapController _mapController;  // Naver Map Controller

  /// Initialize the MapHelper with the map controller
  void initialize(NaverMapController controller) {
    _mapController = controller;
  }

  Future<void> addCleanMarker(double latitude, double longitude) async {
    try {
      // Create a reusable NOverlayImage for the clean marker icon
      final NOverlayImage cleanIconImage = await NOverlayImage.fromAssetImage(
        'assets/icons/clean_marker.png',
      );

      // Create a marker at the specified location
      final cleanMarker = NMarker(
        id: 'clean_marker_${cleanMarkers.length}', // Unique ID
        position: NLatLng(latitude, longitude),
        icon: cleanIconImage,
        size: const Size(24, 36),
      );

      // Add the marker to the map
      cleanMarkers.add(cleanMarker);
      await _mapController.addOverlay(cleanMarker);

      debugPrint('Clean marker added at location: ($latitude, $longitude)');
    } catch (e) {
      debugPrint('Error adding clean marker: $e');
    }
  }

  /// 현재 위치 마커 추가
  Future<void> addCurrentLocationMarker() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 마커 생성
      final marker = NMarker(
        id: 'current_location',
        position: NLatLng(position.latitude, position.longitude),
      );

      // 지도에 마커 추가
      await _mapController.addOverlay(marker);

      debugPrint('현재 위치 마커 추가됨: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('현재 위치 마커 추가 실패: $e');
    }
  }

  /// 쓰레기통 마커 추가
  Future<void> addTrashBinMarkers() async {
    try {
      // Create a reusable NOverlayImage for the trash bin icon
      final NOverlayImage iconImage = await NOverlayImage.fromAssetImage(
        'assets/icons/bin_marker.png',
      );

      // Generate nearby trash bin locations
      final List<NLatLng> nearbyTrashBins = _generateNearbyTrashBins();

      // Create markers with unique IDs and the icon image
      trashBinMarkers.addAll(
        nearbyTrashBins.asMap().entries.map((entry) {
          return NMarker(
            id: 'trash_bin_${entry.key}', // Unique ID for each marker
            position: entry.value,
            icon: iconImage,
            size: const Size(24, 36),
          );
        }),
      );

      // Add all markers to the map
      await _mapController.addOverlayAll(trashBinMarkers.toSet());

      debugPrint('쓰레기통 마커 추가 성공.');
    } catch (e) {
      debugPrint('쓰레기통 마커 추가 실패: $e');
    }
  }

  /// Mock: 쓰레기통 위치 생성
  List<NLatLng> _generateNearbyTrashBins() {
    const double baseLatitude = 37.5665;
    const double baseLongitude = 126.9780;

    return [
      NLatLng(baseLatitude + 0.0015, baseLongitude + 0.002),
      NLatLng(baseLatitude - 0.0015, baseLongitude - 0.002),
      NLatLng(baseLatitude + 0.002, baseLongitude - 0.0018),
      NLatLng(baseLatitude - 0.002, baseLongitude + 0.0018),
    ];
  }
}
