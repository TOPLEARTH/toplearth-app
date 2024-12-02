import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void>requestPermissions() async {
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }

  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }

  if (!await Geolocator.isLocationServiceEnabled()) {
    Get.snackbar('오류', '위치 서비스를 활성화해주세요.');
    return;
  }
}
