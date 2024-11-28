import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toplearth/app/config/color_system.dart';

@immutable
abstract class BaseScreen<T extends GetxController> extends GetView<T> {
  const BaseScreen({super.key});

  // 스크린샷 컨트롤러를 가져오는 메서드 추가
  @protected
  ScreenshotController getScreenshotController() {
    throw UnimplementedError('Screenshot controller not implemented');
  }

  @override
  Widget build(BuildContext context) {
    if (!viewModel.initialized) {
      initViewModel();
    }

    // Screenshot이 필요한 화면인지 확인
    if (needsScreenshot) {
      return Screenshot(
        controller: getScreenshotController(),
        child: _buildBaseContainer(context),
      );
    }

    return _buildBaseContainer(context);
  }


  /// 기존 Container 부분을 별도 메서드로 분리
  Widget _buildBaseContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unSafeAreaColor,
      ),
      child: wrapWithInnerSafeArea
          ? SafeArea(
        top: setTopOuterSafeArea,
        bottom: setBottomOuterSafeArea,
        child: _buildScaffold(context),
      )
          : _buildScaffold(context),
    );
  }

  /// Scaffold를 구성하는 메서드
  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      extendBody: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: screenBackgroundColor,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: buildFloatingActionButton,
      appBar: buildAppBar(context),
      body: wrapWithInnerSafeArea
          ? SafeArea(
              top: setTopInnerSafeArea,
              bottom: setBottomInnerSafeArea,
              child: buildBody(context),
            )
          : buildBody(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }


  // Screenshot 필요 여부를 확인하는 getter (기본값 false)
  @protected
  bool get needsScreenshot => false;

  /// 뷰 모델을 초기화하는 메서드
  @protected
  void initViewModel() {
    viewModel.initialized;
  }

  /// 뷰 모델을 가져오는 메서드
  @protected
  T get viewModel => controller;

  /// SafeArea의 색상을 정의하는 메서드
  @protected
  Color? get unSafeAreaColor => Colors.white;

  /// 키보드가 나타날 때 화면을 조절할지 여부를 정의하는 메서드
  @protected
  bool get resizeToAvoidBottomInset => true;

  /// Floating Action Button을 구성하는 메서드
  @protected
  Widget? get buildFloatingActionButton => null;

  /// Floating Action Button의 위치를 정의하는 메서드
  @protected
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  /// AppBar를 구성하는 메서드
  @protected
  bool get extendBodyBehindAppBar => false;

  /// 화면의 배경 색상을 정의하는 메서드
  @protected
  Color? get screenBackgroundColor => ColorSystem.white;

  /// Scaffold 외부를 SafeArea로 감싸는지 여부를 정의하는 메서드
  @protected
  bool get wrapWithOuterSafeArea => false;

  /// 외부 SafeArea의 위쪽 부분을 설정할지 여부를 정의하는 메서드
  @protected
  bool get setTopOuterSafeArea => throw UnimplementedError();

  /// 외부 SafeArea의 아래쪽 부분을 설정할지 여부를 정의하는 메서드
  @protected
  bool get setBottomOuterSafeArea => throw UnimplementedError();

  /// Scaffold Body를 SafeArea로 감싸는지 여부를 정의하는 메서드
  @protected
  bool get wrapWithInnerSafeArea => false;

  /// 내부 SafeArea의 위쪽 부분을 설정할지 여부를 정의하는 메서드
  @protected
  bool get setTopInnerSafeArea => throw UnimplementedError();

  /// 내부 SafeArea의 아래쪽 부분을 설정할지 여부를 정의하는 메서드
  @protected
  bool get setBottomInnerSafeArea => throw UnimplementedError();

  /// AppBar를 구성하는 메서드
  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// 화면의 본문을 구성하는 메서드로 하위 클래스에서 반드시 구현되어야 함
  @protected
  Widget buildBody(BuildContext context);

  /// 화면 배경 색깔 그라데이션 적용 여부 정의하는 메서드
  bool get useGradientBackground => true;

  /// BottomNavigationBar를 구성하는 메서드
  @protected
  Widget? buildBottomNavigationBar(BuildContext context) => null;
}
