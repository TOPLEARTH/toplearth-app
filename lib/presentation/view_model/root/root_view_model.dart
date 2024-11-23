import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/utility/notification_util.dart';
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';
import 'package:toplearth/domain/repository/user/user_repository.dart';
import 'package:toplearth/domain/usecase/read_user_state_usecase.dart';

class RootViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const duration = Duration(milliseconds: 200);

  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final ReadUserStateUsecase _readUserBriefUsecase;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late Rx<DateTime> _currentAt;
  late final RxInt _selectedIndex;
  late final Rx<UserState> _userState;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  DateTime get currentAt => _currentAt.value;
  int get selectedIndex => _selectedIndex.value;

  UserState get userState => _userState.value;

  @override
  void onInit() async {
    super.onInit();

    // Dependency Injection
    _readUserBriefUsecase = Get.find<ReadUserStateUsecase>();

    _selectedIndex = 2.obs;
    _userState = UserState.initial().obs;

    // FCM Setting
    FirebaseMessaging.onMessage
        .listen(NotificationUtil.showFlutterNotification);
    FirebaseMessaging.onBackgroundMessage(NotificationUtil.onBackgroundHandler);

    // Private Fields
    _currentAt = DateTime.now().obs;
    _selectedIndex = 2.obs;
  }

  void changeIndex(int index) async {
    _selectedIndex.value = index;
    _currentAt.value = DateTime.now();
  }

  @override
  void onReady() async {
    super.onReady();

    _fetchUserInformation();
  }

  void _fetchUserInformation() async {
    StateWrapper<UserState> state = await _readUserBriefUsecase.execute();

    if (state.success) {
      _userState.value = state.data!;
    }
  }
}
