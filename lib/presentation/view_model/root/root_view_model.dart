import 'dart:convert';
import 'dart:core';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:toplearth/app/env/dev/dev_environment.dart';
import 'package:toplearth/app/utility/notification_util.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/global/legacy_info_state.dart';
import 'package:toplearth/domain/entity/global/region_ranking_info_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/domain/entity/home/home_info_state.dart';
import 'package:toplearth/domain/entity/matching/matching_real_time_info_state.dart';
import 'package:toplearth/domain/entity/matching/matching_status_state.dart';
import 'package:toplearth/domain/entity/plogging/plogging_info_state.dart';
import 'package:toplearth/domain/entity/quest/quest_info_state.dart';
import 'package:toplearth/domain/entity/user/boot_strap_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/type/e_matching_status.dart';
import 'package:toplearth/domain/usecase/matching/matching_status_usecase.dart';
import 'package:toplearth/domain/usecase/user/read_user_state_usecase.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';

class RootViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const duration = Duration(milliseconds: 200);

  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final ReadBootStrapUseCase _readBootStrapUseCase;
  late final MatchingStatusUseCase _matchingStatusUseCase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late Rx<DateTime> _currentAt;
  late final RxInt _selectedIndex = RxInt(2);
  late final Rx<UserState> _userState;
  late final Rx<QuestInfoState> _questInfoState;
  late final Rx<TeamInfoState> _teamInfoState;
  late final Rx<PloggingInfoState> _ploggingInfoState;
  late final Rx<LegacyInfoState> _legacyInfoState;
  late final Rx<RegionRankingInfoState> _regionRankingInfoState;
  late final Rx<HomeInfoState> _homeInfoState;
  late final Rx<MatchingRealTimeInfoState> _matchingRealTimeInfoState;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // DateTime get currentAt => _currentAt.value;
  int get selectedIndex => _selectedIndex.value;
  late final EMatchingStatus matchingStatus = EMatchingStatus.WAITING;

  late final Rx<MatchingStatusState> matchingStatusState = MatchingStatusState(
    status: EMatchingStatus.WAITING,
  ).obs;

  UserState get userState => _userState.value;
  QuestInfoState get questInfoState => _questInfoState.value;
  Rx<TeamInfoState> get teamInfoState => _teamInfoState;
  PloggingInfoState get ploggingInfoState => _ploggingInfoState.value;
  LegacyInfoState get legacyInfoState => _legacyInfoState.value;
  RegionRankingInfoState get regionRankingInfoState =>
      _regionRankingInfoState.value;
  HomeInfoState get homeInfoState => _homeInfoState.value;
  MatchingRealTimeInfoState get matchingRealTimeInfoState =>
      _matchingRealTimeInfoState.value;

  RxBool isBootstrapLoaded = false.obs;
  // 전역 상태로 관리할 위치 정보
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString regionName = '현재 위치를 조회해요!'.obs; // 초기 상태
  RxInt regionId = 0.obs;
  @override
  void onInit() async {
    super.onInit();

    // Dependency Injection
    _readBootStrapUseCase = Get.find<ReadBootStrapUseCase>();
    _matchingStatusUseCase = Get.find<MatchingStatusUseCase>();

    // // 초기 매칭 상태 조회
    // await fetchMatchingStatus();

    _userState = UserState.initial().obs;
    _questInfoState = QuestInfoState.initial().obs;
    _teamInfoState = TeamInfoState.initial().obs;
    _ploggingInfoState = PloggingInfoState.initial().obs;
    _legacyInfoState = LegacyInfoState.initial().obs;
    _regionRankingInfoState = RegionRankingInfoState.initial().obs;
    _homeInfoState = HomeInfoState.initial().obs;
    _matchingRealTimeInfoState = MatchingRealTimeInfoState.initial().obs;

    // FCM Setting
    FirebaseMessaging.onMessage
        .listen(NotificationUtil.showFlutterNotification);
    FirebaseMessaging.onBackgroundMessage(NotificationUtil.onBackgroundHandler);
    // Private Fields
    _currentAt = DateTime.now().obs;

    fetchMatchingStatus();
  }

  // 매칭 상태 조회
  Future<void> fetchMatchingStatus() async {
    final StateWrapper<MatchingStatusState> state =
        await _matchingStatusUseCase.execute();

    if (state.success) {
      debugPrint('매칭 상태 조회 성공');
      matchingStatusState.value = MatchingStatusState(
        status: state.data!.status,
      );
      debugPrint('MatchingStatusState: ${matchingStatusState.value.status}');
    } else {
      debugPrint('매칭 상태 조회 실패: ${state.message}');
    }
  }

// RootViewModel
  void updateTeamIdInMatchingGroupViewModel() {
    final matchingGroupViewModel = Get.find<MatchingGroupViewModel>();

    // 초기 teamId 전달
    matchingGroupViewModel.setTeamId(_teamInfoState.value.teamId ?? 0);

    // teamInfoState 변경 시 MatchingGroupViewModel 업데이트
    ever(_teamInfoState, (teamInfoState) {
      matchingGroupViewModel.setTeamId(teamInfoState.teamId ?? 0);
    });
  }

  // 위치 권한 요청 및 현재 위치 가져오기
  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 비활성화되었습니다.');
    }

    // 위치 권한 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude.value = position.latitude;
    longitude.value = position.longitude;

    // 지역 정보 가져오기
    await _fetchRegionInfo(position.latitude, position.longitude);
  }

  // 위도/경도를 기반으로 지역 및 regionId 조회
  Future<void> _fetchRegionInfo(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        String? area = placemarks.first.subAdministrativeArea;

        if (area == null || !area.contains('구')) {
          area = await fetchRegionFromNaverAPI(lat, lng);
        }

        if (area != null && area.contains('구')) {
          regionName.value = '서울시 $area';
          regionId.value = _getRegionId(area); // regionId 업데이트
          debugPrint("Updated regionId in RootViewModel: ${regionId.value}");
        } else {
          regionName.value = '지역 정보를 찾을 수 없습니다.';
          regionId.value = 0;
        }
      } else {
        debugPrint('No placemarks found for the coordinates.');
      }
    } catch (e) {
      debugPrint('Error fetching region info: $e');
    }
  }

  void changeIndex(int index) async {
    _selectedIndex.value = index;
    _currentAt.value = DateTime.now();
  }

  @override
  @override
  void onReady() async {
    super.onReady();

    await fetchBootstrapInformation(); // teamInfoState를 로드
    debugPrint('RootViewModel: teamInfoState: ${teamInfoState.value}');
  }


  Future<void> fetchBootstrapInformation() async {
    StateWrapper<BootstrapState> state = await _readBootStrapUseCase.execute();

    if (state.success) {
      // debugPrint('bootstrap: ${state.data!.userInfo}');

      _userState.value = state.data!.userInfo;
      _homeInfoState.value = state.data!.homeInfo;
      _teamInfoState.value = state.data!.teamInfo;
      if (state.data?.teamInfo != null) {
        updateTeamIdInMatchingGroupViewModel();
      }
      _questInfoState.value = state.data!.questInfo;
      _ploggingInfoState.value = state.data!.ploggingInfo;
      _legacyInfoState.value = state.data!.legacyInfo;
      _regionRankingInfoState.value = state.data!.regionRankingInfo;
      _homeInfoState.value = state.data!.homeInfo;
      if (state.data?.matchingRealTimeInfo != null) {
        _matchingRealTimeInfoState.value = state.data!.matchingRealTimeInfo!;
      }
      debugPrint('PloggingInfo: ${_ploggingInfoState.value}');
      isBootstrapLoaded.value = true; // 로드 완료 상태 업데이트
    }
    debugPrint('isBootstrapLoaded: ${isBootstrapLoaded.value}');
  }

  int _getRegionId(String? areaName) {
    const Map<String, int> regionMapping = {
      '용산구': 1,
      '서초구': 2,
      '강남구': 3,
      '송파구': 4,
      '강동구': 5,
      '광진구': 6,
      '중랑구': 7,
      '노원구': 8,
      '도봉구': 9,
      '강북구': 10,
      '성북구': 11,
      '동대문구': 12,
      '성동구': 13,
      '중구': 14,
      '종로구': 15,
      '서대문구': 16,
      '은평구': 17,
      '마포구': 18,
      '강서구': 19,
      '양천구': 20,
      '영등포구': 21,
      '구로구': 22,
      '금천구': 23,
      '관악구': 24,
      '동작구': 25,
    };
    return regionMapping[areaName] ?? 0; // 지역이 없으면 기본값 0 반환
  }
}

Future<String?> fetchRegionFromNaverAPI(double lat, double lng) async {
  final String apiUrl =
      "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc";

  final response = await http.get(
    Uri.parse(
        "$apiUrl?request=coordsToaddr&coords=$lng,$lat&sourcecrs=epsg:4326&output=json&orders=legalcode,admcode"),
    headers: {
      "X-NCP-APIGW-API-KEY-ID": DevEnvironment.NAVER_CLIENT_ID,
      "X-NCP-APIGW-API-KEY": DevEnvironment.NAVER_CLIENT_SECRET,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    try {
      final String region = data["results"][0]["region"]["area2"]["name"];
      return region; // 지역구 반환
    } catch (e) {}
  } else {}
  return null;
}
