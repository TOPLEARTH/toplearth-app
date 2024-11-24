import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:math' as math;
class PloggingController extends GetxController {
  // Map Controller
  late NaverMapController _mapController;

  // State Variables
  RxBool isTracking = false.obs;
  Rx<Duration> ploggingTime = Duration.zero.obs;
  Timer? _timer;

  // Locations
  RxList<NLatLng> routeCoordinates = <NLatLng>[].obs;
  NLatLng? _currentLocation; // Last known location
  RxDouble currentZoom = 16.0.obs; // Initial zoom level

  // Trash bin markers
  RxList<NMarker> trashBinMarkers = <NMarker>[].obs;

  // Initialize Controller
  void onMapReady(NaverMapController controller) {
    _mapController = controller;
    _addTrashBinMarkers(); // Add markers when the map is ready
  }

  Future<void> zoomIn() async {
    if (_mapController != null) {
      currentZoom.value = (currentZoom.value + 1).clamp(0.0, 21.0); // Max zoom level is 21
      await _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: _currentLocation ?? NLatLng(37.5665, 126.9780),
            zoom: currentZoom.value,
          ),
        ),
      );
    }
  }

  Future<void> zoomOut() async {
    if (_mapController != null) {
      currentZoom.value = (currentZoom.value - 1).clamp(0.0, 21.0); // Min zoom level is 0
      await _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: _currentLocation ?? NLatLng(37.5665, 126.9780),
            zoom: currentZoom.value,
          ),
        ),
      );
    }
  }

  Future<void> startPlogging() async {
    isTracking.value = true;
    if (routeCoordinates.isEmpty) {
      // Only set a default start location if no route exists
      _currentLocation = NLatLng(37.5665, 126.9780); // Default start location (Seoul)
      routeCoordinates.add(_currentLocation!);
    }
    _startTimer();
  }

  Future<void> stopPlogging() async {
    isTracking.value = false;
    _stopTimer();
    if (routeCoordinates.isNotEmpty) {
      Get.defaultDialog(
        title: "Plogging Complete",
        content: Text("Total Time: ${_formatDuration(ploggingTime.value)}"),
        onConfirm: () {
          Get.back();
        },
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      ploggingTime.value += const Duration(seconds: 2);
      _updateCurrentLocation();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _updateCurrentLocation() async {
    // Mock current location with a 1-meter movement
    final newLocation = _currentLocation ?? NLatLng(37.5665, 126.9780);
    final nextLocation = _getNewLocationByDistance(newLocation, 1); // 1-meter movement

    _currentLocation = nextLocation;
    routeCoordinates.add(nextLocation);

    await _drawPath();

    // Move camera to the current location
    if (_mapController != null) {
      await _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(NCameraPosition(
          target: nextLocation,
          zoom: currentZoom.value,
        )),
      );
    }
  }

  /// Calculate a new location by moving a certain distance in meters
  NLatLng _getNewLocationByDistance(NLatLng currentLocation, double distanceInMeters) {
    const double earthRadius = 6371000; // Earth's radius in meters
    final double latOffset = (distanceInMeters / earthRadius) * (180 / math.pi);
    final double lngOffset = (distanceInMeters / earthRadius) *
        (180 / math.pi) /
        math.cos(currentLocation.latitude * math.pi / 180);

    return NLatLng(
      currentLocation.latitude + latOffset,
      currentLocation.longitude + lngOffset,
    );
  }

  Future<void> _drawPath() async {
    if (routeCoordinates.isNotEmpty) {
      final pathOverlay = NPathOverlay(
        id: 'plogging',
        coords: routeCoordinates,
        width: 12,
        color: Colors.green,
      );
      await _mapController.addOverlay(pathOverlay);
    }
  }

  Future<void> _addTrashBinMarkers() async {
    final iconImage = await const NOverlayImage.fromAssetImage('assets/icons/test_marker.png');
    final List<NLatLng> nearbyTrashBins = _generateNearbyTrashBins();

    // Generate markers with tap listeners
    trashBinMarkers.value = nearbyTrashBins
        .asMap()
        .entries
        .map((entry) => NMarker(
      id: 'trash_bin_${entry.key}',
      position: entry.value,
      icon: iconImage,
      // onTap: (marker) {
      //   // Show a modal or perform an action
      //   Get.defaultDialog(
      //     title: "Trash Bin Details",
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text("Marker ID: ${marker.info.id}"),
      //         Text("Position: ${marker.position.latitude}, ${marker.position.longitude}"),
      //         const SizedBox(height: 10),
      //         ElevatedButton(
      //           onPressed: () => Get.back(), // Close dialog
      //           child: const Text("Close"),
      //         ),
      //       ],
      //     ),
      //   );
      // },
    ))
        .toList();

    // Add markers to the map
    await _mapController.addOverlayAll(trashBinMarkers.toSet());
  }


  List<NLatLng> _generateNearbyTrashBins() {
    final baseLocation = _currentLocation ?? NLatLng(37.5665, 126.9780);
    return [
      _getNewLocationByDistance(baseLocation, 10), // 10m away
      _getNewLocationByDistance(baseLocation, 20),
      _getNewLocationByDistance(baseLocation, 30),
      _getNewLocationByDistance(baseLocation, 40),
      _getNewLocationByDistance(baseLocation, 50),
    ];
  }

  void _showTrashBinDetails(NMarker marker) {
    Get.defaultDialog(
      title: "Trash Bin Details",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Marker ID: ${marker.info.id}"),
          Text("Position: ${marker.position.latitude}, ${marker.position.longitude}"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Get.back(), // Close dialog
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class NaverMapScreen extends StatelessWidget {
  final PloggingController controller = Get.put(PloggingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isTracking.value
              ? "Tracking: ${controller.ploggingTime.value.inSeconds}s"
              : "Plogging",
        )),
      ),
      body: Stack(
        children: [
          NaverMap(
            onMapReady: controller.onMapReady,
          ),
          if (!controller.isTracking.value)
            Center(
              child: ElevatedButton(
                onPressed: () => controller.startPlogging(),
                child: const Text("Start Plogging"),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => controller.zoomIn(),
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => controller.zoomOut(),
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: 10),
          Obx(
                () => FloatingActionButton.extended(
              onPressed: controller.isTracking.value
                  ? () => controller.stopPlogging()
                  : () => controller.startPlogging(),
              label: Text(controller.isTracking.value ? "Stop Plogging" : "Start Plogging"),
              icon: Icon(controller.isTracking.value ? Icons.stop : Icons.play_arrow),
            ),
          ),
        ],
      ),
    );
  }
}

