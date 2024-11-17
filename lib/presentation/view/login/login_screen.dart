import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/presentation/view_model/login/login_view_model.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';

class LoginScreen extends GetView<LoginViewModel> {
  const LoginScreen({super.key});

  LoginViewModel get viewModel => controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_default_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 500),
          RoundedRectangleTextButton(
            text: '카카오로 로그인',
            icon: Image.asset(
              'assets/images/kakaotalk-logo.png',
              width: 24,
              height: 24,
            ),
            backgroundColor: const Color(0xFFFEE500),
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () async {
              await viewModel.loginByKakao().then((value) {
                if (value.success) {
                  Get.offAndToNamed(AppRoutes.ROOT);
                } else {
                  Get.snackbar("로그인 실패", value.message!);
                }
              });
            },
          ),
          const SizedBox(height: 10),
        RoundedRectangleTextButton(
          text: 'Apple로 로그인',
          icon: const Icon(
            Icons.apple,
            size: 24,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () async {
            await viewModel.loginByApple().then((value) {
              if (value.success) {
                Get.offAndToNamed(AppRoutes.ROOT);
              } else {
                Get.snackbar("로그인 실패", value.message!);
              }
            });
          },
        ),
        ],
        ),
      ),
    );
  }
}
