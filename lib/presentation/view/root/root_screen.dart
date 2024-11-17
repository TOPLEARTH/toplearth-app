import 'package:flutter/material.dart';
import 'package:toplearth/MessagePage.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/local_push_notifications.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    LocalPushNotifications.init();  // 푸시 알림 초기화
    LocalPushNotifications.notificationStream.stream.listen((payload) {
      if (payload.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagePage(payload: payload),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Toplearth Root Screen',
              style: FontSystem.H6,
            ),
            ElevatedButton(
              onPressed: () {

                LocalPushNotifications.showSimpleNotification(
                  title: '투플러스',
                  body: '10시 플로깅 대전 매칭에 성공했습니다!',
                  payload: '일반 알림 데이터',
                );
              },
              child: const Text("일반 푸시 알림"),
            ),
          ],
        ),
      ),
    );
  }
}