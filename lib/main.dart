import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:toplearth/app/env/common/environment_factory.dart';
import 'package:toplearth/app/env/dev/dev_environment.dart';
import 'package:toplearth/app/utility/health_util.dart';
import 'package:toplearth/app/utility/notification_util.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/main_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toplearth/firebase_options.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  await onInitSystem();
  await onReadySystem();

  runApp(const MainApp());
}

Future<void> onInitSystem() async {
  // Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NaverMapSdk.instance.initialize(
    clientId: DevEnvironment.NAVER_CLIENT_ID,
  );

  KakaoSdk.init(nativeAppKey: DevEnvironment.KAKAO_APP_KEY);


  // Firebase foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationUtil.showFlutterNotification(message);
  });
  FirebaseMessaging.onBackgroundMessage(NotificationUtil.onBackgroundHandler);

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
