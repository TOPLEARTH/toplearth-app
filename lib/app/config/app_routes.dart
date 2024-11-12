// ignore_for_file: constant_identifier_names

abstract class AppRoutes {
  // 스플래시, 온보딩, 로그인
  static const String SPLASH = '/splash';
  static const String ON_BOARDING = '/on-boarding';
  static const String LOGIN = '/login';

  // 플로깅 시작전, 진행중, 끝난후 인증, 끝난후 라벨링
  static const String PLOGGING_PREPARE = '/plogging-prepare';      // 시작 전 화면
  static const String PLOGGING_PROGRESS = '/plogging-progress';    // 진행 중 화면
  static const String PLOGGING_VERIFY = '/plogging-verify';        // 끝난 후 인증 화면
  static const String PLOGGING_LABELING = '/plogging-labeling';

  // 그룹 생성, 그룹 참여, 그룹 생성(가입) 완료
  static const String GROUP_CREATE = '/group-create';
  static const String GROUP_JOIN = '/group-join';
  static const String GROUP_COMPLETE = '/group-complete';

  // 루트 탭
  static const String ROOT = '/';

  // 앱 설정
  static const String APP_SETTING = '/app-setting';
}
