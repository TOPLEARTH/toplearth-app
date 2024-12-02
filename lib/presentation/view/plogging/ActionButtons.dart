// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:toplearth/app/config/color_system.dart';
// import 'package:toplearth/core/view/base_widget.dart';
// import 'package:toplearth/presentation/view/plogging/request_permission.dart';
// import 'package:toplearth/presentation/view_model/plogging/plogging_view_model.dart';
//
// class ActionButtons extends BaseWidget<PloggingViewModel> {
//   const ActionButtons({super.key});
//
//   @override
//   Widget buildView(BuildContext context) {
//     return Column(
//       children: [
//         _buildButton(
//           label: '사진 찍기',
//           icon: Icons.camera_alt,
//           onTap: () async {
//             await requestPermissions();
//             final picker = ImagePicker();
//             final position = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high,
//             );
//
//             final XFile? photo =
//             await picker.pickImage(source: ImageSource.camera);
//             if (photo != null) {
//               viewModel.setSelectedImage(File(photo.path));
//               await viewModel.addMarkerAtCurrentLocationWithCoordinates(
//                 position.latitude,
//                 position.longitude,
//               );
//               await viewModel.uploadImage(
//                 position.latitude,
//                 position.longitude,
//               );
//             }
//           },
//         ),
//         const SizedBox(height: 16),
//         _buildButton(
//           label: '사진 업로드',
//           icon: Icons.upload_file,
//           onTap: () async {
//             final picker = ImagePicker();
//             final XFile? file =
//             await picker.pickImage(source: ImageSource.gallery);
//             if (file != null) {
//               viewModel.setSelectedImage(File(file.path));
//               final position = await Geolocator.getCurrentPosition(
//                 desiredAccuracy: LocationAccuracy.high,
//               );
//               await viewModel.addMarkerAtCurrentLocationWithCoordinates(
//                 position.latitude,
//                 position.longitude,
//               );
//               await viewModel.uploadImage(
//                 position.latitude,
//                 position.longitude,
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildButton({
//     required String label,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(24),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: ColorSystem.main,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Icon(icon, size: 24, color: ColorSystem.main),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
