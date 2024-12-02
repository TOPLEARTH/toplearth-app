import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:toplearth/test_code/NaverMapScreen.dart';

class LocalPushNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final StreamController<String> notificationStream =
  StreamController<String>.broadcast();

  static Future init() async {
    // Android 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 초기화 설정
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Android 및 iOS 초기화 설정 통합
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // iOS 설정 추가
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    tz.initializeTimeZones();
  }

  /// 푸시 알림 클릭 시 동작
  static void onNotificationTap(NotificationResponse notificationResponse) {
    String? payload = notificationResponse.payload;
    debugPrint("Notification tapped with payload: $payload");

    // mingiId를 활용한 화면 전환
    if (payload != null) {
      switch (payload) {
        case '':
          Get.to(() => NaverMapScreen());
          break;
        default:
          debugPrint("Unhandled payload: $payload");
      }
    }
  }


  /// 푸시 알림 수동 트리거
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Firebase 메시지 처리 및 로컬 알림 표시
  static Future<void> handleFirebaseMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data['payload'], // 알림 데이터 포함
      );
    }
  }
}
