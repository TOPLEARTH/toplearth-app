import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class DynamicMapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final RxList<NMarker> markers;

  const DynamicMapView({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(latitude, longitude),
            zoom: 15,
          ),
        ),
        onMapReady: (controller) {
          // Center the map on the user's current location
          controller.updateCamera(NCameraUpdate.fromCameraPosition(
            NCameraPosition(
              target: NLatLng(latitude, longitude),
              zoom: 15,
            ),
          ));
        },
      );
    });
  }
}
