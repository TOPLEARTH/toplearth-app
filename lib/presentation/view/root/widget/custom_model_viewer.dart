import 'package:model_viewer_plus/model_viewer_plus.dart';

class CustomModelViewer extends ModelViewer {
  final bool isScrollable;

  const CustomModelViewer({
    super.key,
    required super.src,
    this.isScrollable = false,
    super.alt,
    super.ar,
    super.arModes,
    super.arScale,
    super.arPlacement,
    super.autoRotate,
    super.autoRotateDelay,
    super.autoPlay,
    super.cameraControls = false,
    super.iosSrc,
    super.loading,
    super.poster,
    super.reveal,
    super.touchAction = TouchAction.none,
    super.environmentImage,
    super.skyboxImage,
    super.cameraOrbit,
    super.cameraTarget,
    super.fieldOfView,
    super.maxCameraOrbit,
    super.maxFieldOfView,
    super.minCameraOrbit,
    super.minFieldOfView,
    super.animationName,
    super.animationCrossfadeDuration,
    super.orientation,
    super.scale,
    super.disableZoom,
    super.debugLogging,
    super.disablePan,
    super.disableTap,
    required super.backgroundColor,
    super.onWebViewCreated,
    String? variant,
  }) : super(
          relatedCss: isScrollable
              ? null
              : '''
            model-viewer {
              --poster-color: transparent;
              --progress-bar-color: #ff0000;
              --progress-mask: transparent;
              -webkit-user-drag: none;
              -khtml-user-drag: none;
              -moz-user-drag: none;
              -o-user-drag: none;
              user-drag: none;
            }
            html, body {
              overflow: hidden;
              -webkit-overflow-scrolling: none;
              overscroll-behavior: none;
            }
            model-viewer::part(default-progress-bar) {
              display: none;
            }
            * {
              -webkit-user-select: none;
              -khtml-user-select: none;
              -moz-user-select: none;
              -ms-user-select: none;
              user-select: none;
              -webkit-tap-highlight-color: transparent;
            }
            body {
              -webkit-user-select: none;
              -moz-user-select: none;
              -ms-user-select: none;
              user-select: none;
            }
          ''',
        );
}
