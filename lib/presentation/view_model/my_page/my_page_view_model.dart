import 'package:get/get.dart';
import 'package:toplearth/domain/entity/plogging/plogging_info_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/presentation/view_model/root/root_view_model.dart';

class MyPageViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final RootViewModel _rootViewModel;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final Rx<QuestInfoState> _questInfoState;
  late final Rx<PloggingInfoState> _ploggingInfoState;
  late final RxString _selectedTab;
  late final RxInt _selectedDayIndex;
  // 현재 선택된 날짜
  late final Rx<DateTime> selectedDate = DateTime.now().obs;

  // 현재 포커스된 날짜 (캘린더 이동 시 사용)
  late final Rx<DateTime> focusedDate = DateTime.now().obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  QuestInfoState get questInfoState => _questInfoState.value;
  PloggingInfoState get ploggingInfoState => _ploggingInfoState.value;
  String get selectedTab => _selectedTab.value;
  int get selectedDayIndex => _selectedDayIndex.value;
  @override
  void onInit() {
    super.onInit();

    // RootViewModel DI 설정
    _rootViewModel = Get.find<RootViewModel>();

    // 초기값 세팅 (빈 값 대체)
    _questInfoState = QuestInfoState.initial().obs;
    _ploggingInfoState = PloggingInfoState.initial().obs;
    _selectedTab = 'DAILY 퀘스트'.obs;
    _selectedDayIndex = 2.obs;

    // RootViewModel의 isBootstrapLoaded 상태 변화를 감지
    ever(_rootViewModel.isBootstrapLoaded, (isLoaded) {
      if (isLoaded) {
        // Bootstrap 데이터가 로드된 이후 업데이트
        _questInfoState.value = _rootViewModel.questInfoState; //
        _ploggingInfoState.value = _rootViewModel.ploggingInfoState;
      }
    });
  }

  // 탭 변경
  void toggleTab(String tab) {
    if (tab == 'DAILY 퀘스트' || tab == '내 플로깅') {
      _selectedTab.value = tab;
    }
  }

  // 요일 선택
  void selectDay(int index) {
    if (index >= 0 && index <= 6) {
      _selectedDayIndex.value = index;
    }
  }

  // 특정 날짜의 플로깅 데이터 가져오기
  List<PloggingState> getPloggingForSelectedDate() {
    final dateKey = _formatDate(selectedDate.value);
    return ploggingInfoState.ploggingList[dateKey] ?? [];
  }

  // 특정 날짜가 플로깅 완료된 상태인지 확인
  bool isPloggingCompleted(DateTime date) {
    final dateKey = _formatDate(date);
    return ploggingInfoState.ploggingList.containsKey(dateKey);
  }

  // 선택된 날짜 업데이트
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // 포커스된 날짜 업데이트
  void updateFocusedDate(DateTime date) {
    focusedDate.value = date;
  }

  // 이번 달 완료된 플로깅 횟수 가져오기
  int getCompletedCountForMonth() {
    final now = DateTime.now();
    return ploggingInfoState.ploggingList.keys.where((dateKey) {
      final parsedDate = DateTime.parse(dateKey);
      return parsedDate.year == now.year && parsedDate.month == now.month;
    }).length;
  }

  // 날짜 포맷 변환 (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
// import 'package:get/get.dart';
// import 'package:toplearth/domain/entity/group/team_info_state.dart';
// import 'package:toplearth/domain/entity/group/monthly_group_state.dart';
// import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
//
// class GroupViewModel extends GetxController {
//   /* ------------------------------------------------------ */
//   /* -------------------- DI Fields ----------------------- */
//   /* ------------------------------------------------------ */
//   late final RootViewModel _rootViewModel;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Private Fields --------------------- */
//   /* ------------------------------------------------------ */
//   final Rx<TeamInfoState> _teamInfoState = TeamInfoState.initial().obs;
//
//   /* ------------------------------------------------------ */
//   /* ----------------- Public Fields ---------------------- */
//   /* ------------------------------------------------------ */
//   TeamInfoState get teamInfoState => _teamInfoState.value;
//
//   MonthlyGroupState? get currentMonthData {
//     final currentMonth = DateTime.now().toIso8601String().substring(0, 7); // e.g., "2024-12"
//     return teamInfoState.monthlyData[currentMonth];
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // RootViewModel DI 설정
//     _rootViewModel = Get.find<RootViewModel>();
//     // Private Fields 초기화
//     _teamInfoState.value = _rootViewModel.teamInfoState;
//   }
// }
