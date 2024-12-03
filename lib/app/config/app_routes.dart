// ignore_for_file: constant_identifier_names

abstract class AppRoutes {
  // 스플래시, 온보딩, 로그인
  static const String SPLASH = '/splash';
  static const String ON_BOARDING = '/on-boarding';
  static const String LOGIN = '/login';

  static const String LEGACY = '/legacy';

  static const String REPORT = '/report';

  // 플로깅 시작전, 진행중, 끝난후 인증, 끝난후 라벨링
  static const String PLOGGING = '/plogging';
  static const String PLOGGING_PREPARE = '/plogging-prepare';      // 시작 전 화면
  static const String PLOGGING_PROGRESS = '/plogging-progress';    // 진행 중 화면
  static const String PLOGGING_VERIFY = '/plogging-verify';        // 끝난 후 인증 화면
  static const String PLOGGING_LABELING = '/plogging-labeling';
  static const String PLOGGING_SHARE = '/plogging-share';
  static const String PLOGGING_RECENT = '/plogging-recent';

  // 스토어 상세
  static const String STORE_DETAIL = '/store-detail';

  // 그룹 생성, 그룹 참여, 그룹 생성(가입) 완료
  static const String GROUP_CREATE = '/group-create';
  static const String GROUP_SEARCH = '/group-search';
  static const String GROUP_SELECT = '/group-select';
  static const String GROUP_CREATE_COMPLETE = '/group-create-complete';
  static const String GROUP_JOIN = '/group-join';
  static const String GROUP_COMPLETE = '/group-complete';

  static const String TEST_CODE = '/test-code';




  // 루트 탭
  static const String ROOT = '/';

  // 앱 설정
  static const String APP_SETTING = '/app-setting';
  static const String APP_ALARM = '/app-alarm';
}
