import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/presentation/widget/image/png_image_view.dart';
import 'package:toplearth/presentation/widget/image/svg_image_view.dart';

class HomeMapSwitcherView extends StatefulWidget {
  const HomeMapSwitcherView({super.key});

  @override
  State<HomeMapSwitcherView> createState() => _HomeMapSwitcherViewState();
}

class _HomeMapSwitcherViewState extends State<HomeMapSwitcherView> {
  bool showEarthView = true;
  bool showModal = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '서울시 중구',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF607D8B),
              ),
            ),
            const SizedBox(width: 4),
            const SvgImageView(
              assetPath: 'assets/icons/location.svg',
              height: 16,
              width: 16,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  showEarthView = !showEarthView; // Toggle the view
                });
              },
              icon: Icon(
                showEarthView ? Icons.map : Icons.public,
                color: const Color(0xFF607D8B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Earth or Map View
        Stack(
          alignment: Alignment.center,
          children: [
            if (showEarthView)
              const UserEarthView()
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    showModal = true; // Show modal
                  });
                },
                child: const UserMapView(),
              ),
            if (showModal)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showModal = false; // Close modal when tapping outside
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Semi-transparent overlay for the map region
                      Container(
                        color: const Color(0xFFF2F3F5).withOpacity(0.8), // Semi-transparent background
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "중구는 현재\n서울시에서 1등이에요!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2A4F),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Map region and percentage
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              PngImageView(
                                assetPath: 'assets/images/sample_modal_shot.png', // Replace with your region PNG
                                height: 200, // Adjust dimensions
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// UserEarthView
class UserEarthView extends StatelessWidget {
  const UserEarthView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.LEGACY); // Navigate to the Earth view
      },
      child: Container(
        height: 300, // Adjust the height as needed
        width: double.infinity,
        alignment: Alignment.center,
        child: const PngImageView(
          assetPath: 'assets/images/earth_view.png', // Replace with your earth image path
        ),
      ),
    );
  }
}

// UserMapView
class UserMapView extends StatelessWidget {
  const UserMapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color mapping for IDs (100-900) in your SVG
    const Map<String, Color> colorMap = {
      '1': Color(0xFFEBF3FA), // 50
      '2': Color(0xFFD9E8F6), // 100
      '3': Color(0xFFAFCCEC), // 200
      '4': Color(0xFF8AB0D9), // 300
      '5': Color(0xFF6A94C4), // 400
      '6': Color(0xFF4F7AAE), // 500
      '7': Color(0xFF3A6495), // 600
      '8': Color(0xFF2A4F7A), // 700
      '9': Color(0xFF1A3A5F), // 800
      '10': Color(0xFF0F2A4F), // 900
    };

    return Container(
      height: 300, // Adjust the height as needed
      width: double.infinity,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/images/seoul/seoul.svg',
        height: 300, // Adjust the height as needed
        width: double.infinity, // Adjust the width as needed
        colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.srcIn),
        placeholderBuilder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(),
        ),
        theme: SvgTheme(
          currentColor: colorMap['1']!, // Default color, dynamically updated below
        ),
      ),
    );
  }
}
