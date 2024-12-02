import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapControllerManager {
  MapControllerManager._privateConstructor();

  static final MapControllerManager _instance =
  MapControllerManager._privateConstructor();

  factory MapControllerManager() => _instance;

  NaverMapController? _controller;

  void setController(NaverMapController controller) {
    _controller = controller;
  }

  NaverMapController? get controller => _controller;

  bool get isControllerInitialized => _controller != null;

  Future<void> updateCamera(NCameraUpdate update) async {
    if (_controller != null) {
      await _controller!.updateCamera(update);
    }
  }

  /// Add overlays that conform to `NAddableOverlay`
  Future<void> addOverlay(NAddableOverlay overlay) async {
    if (_controller != null) {
      await _controller!.addOverlay(overlay);
    }
  }

  /// Clear all overlays from the map
  Future<void> clearOverlays() async {
    if (_controller != null) {
      await _controller!.clearOverlays();
    }
  }
}
