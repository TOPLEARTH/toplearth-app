import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/env/common/environment_factory.dart';
import 'package:toplearth/app/env/dev/dev_environment.dart';
import 'package:toplearth/app/utility/health_util.dart';
import 'package:toplearth/app/utility/notification_util.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/firebase_options.dart';
import 'package:toplearth/local_push_notifications.dart';
import 'package:toplearth/main_app.dart';

void main() async {
  await onInitSystem();
  await onReadySystem();
  FlutterNativeSplash.remove();

  runApp(const MainApp());
}

// Background 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> onInitSystem() async {
  // Widget Binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase Initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //  Local Push Notification Initialize
  await LocalPushNotifications.init();

  // Naver Map Initialize
  await NaverMapSdk.instance.initialize(
    clientId: DevEnvironment.NAVER_CLIENT_ID,
  );
  // Kakao Initialize
  KakaoSdk.init(nativeAppKey: DevEnvironment.KAKAO_APP_KEY);

  // Firebase foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationUtil.showFlutterNotification(message);
  });
  FirebaseMessaging.onBackgroundMessage(NotificationUtil.onBackgroundHandler);

  // 알림 클릭 시 초기 화면 전환 처리
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    print('getInitialMessage: $message');
    if (message != null) {
      LocalPushNotifications.handleFirebaseMessage(message);
    }
  });

  // 백그라운드 알림 클릭 시 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      debugPrint("🚀 백그라운드 알림 클릭됨!");
      debugPrint("🔗 클릭된 알림의 메시지 ID: ${message.messageId}");
      debugPrint("🔗 클릭된 알림의 데이터: ${message.data}");

      // 클릭한 알림의 mingiId를 로그 출력
      if (message.data.containsKey('mingiId')) {
        print("🔗 알림에서 받은 mingiId: ${message.data['mingiId']}");
      }

      AlertDialog alert = const AlertDialog(
        title: Text("알림 클릭됨!"),
        content: Text("알림 클릭됨!"),
      );
      // 원하는 화면으로 네비게이트
      Get.toNamed(AppRoutes.LEGACY);
    },
  );

  // Health Initialize
  await HealthUtil.initialize();

  // Notification Initialize
  await NotificationUtil.initialize();
  await NotificationUtil.setupRemoteNotification();

  // Environment
  await EnvironmentFactory.onInit();

  // DateTime Formatting
  await initializeDateFormatting();
  tz.initializeTimeZones();

  // Storage & Database Initialize
  await StorageFactory.onInit();
  await StorageFactory.onReady();

  // FCM 토큰 저장
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  await StorageFactory.systemProvider.setFCMToken(fcmToken ?? '');

  // Permission
  await Permission.activityRecognition.request();
}

Future<void> onReadySystem() async {
  // Storage & Database
  await StorageFactory.onReady();

  // If new download app, remove tokens
  // When token exists, isFirstRun is false
  bool isFirstRun = StorageFactory.systemProvider.getFirstRun();

  if (isFirstRun) {
    await StorageFactory.systemProvider.deallocateTokens();
    await StorageFactory.systemProvider.setFirstRun(false);
  }
}
