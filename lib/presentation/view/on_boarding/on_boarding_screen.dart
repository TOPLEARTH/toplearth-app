import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/presentation/widget/button/common/rounded_rectangle_text_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController _pageController;
  late final RxInt _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      _currentPage.value = _pageController.page!.round();
    });

    _currentPage = 0.obs;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: Get.height * 0.85,
              child: PageView(
                controller: _pageController,
                children: [
                  Image.asset('assets/images/on_boarding_1.png'),
                  Image.asset('assets/images/on_boarding_2.png'),
                  Image.asset('assets/images/on_boarding_3.png'),
                  Image.asset('assets/images/on_boarding_4.png'),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: const WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: ColorSystem.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                        () => RoundedRectangleTextButton(
                      text: _currentPage.value == 3 ? '시작하기' : '다음',
                      backgroundColor: ColorSystem.primary,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorSystem.white,
                      ),
                      onPressed: () {
                        if (_currentPage.value == 3) {
                          Get.offAllNamed(AppRoutes.LOGIN);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
