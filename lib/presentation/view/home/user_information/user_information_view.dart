// import 'package:flutter/material.dart';
// import 'package:toplearth/core/provider/base_socket.dart';
// import 'package:toplearth/core/view/base_widget.dart';
// import 'package:toplearth/presentation/view/home/user_information/user_progress_bar.dart';
// import 'package:toplearth/presentation/view_model/root/root_view_model.dart';
//
// class HomeUserInfoView extends BaseWidget<RootViewModel> {
//   const HomeUserInfoView({super.key});
//
//   @override
//   Widget buildView(BuildContext context) {
//     // 뷰모델 데이터
//     final String userName = viewModel.userState.nickname;
//     final int daysTogether = viewModel.userState.daysTogether;
//     final double currentProgress = viewModel.userState.currentProgress;
//     final int lastWeekSessions = viewModel.userState.lastWeekSessions;
//     final int lastWeekDuration = viewModel.userState.lastWeekDuration;
//     final int lastWeekCalories = viewModel.userState.lastWeekCalories;
//
//
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 상단 텍스트
//         Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             '$userName님과 플로깅 동행\n${daysTogether}일째',
//             textAlign: TextAlign.right,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             const Text('주간 목표'),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {
//                 print('목표 설정하기 tapped');
//               },
//               child: const Text(
//                 '목표 설정하기',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         // ProgressBar 컴포넌트
//         UserProgressBar(
//           progress: currentProgress, // 진행률
//           height: 10, // 높이
//           backgroundColor: const Color(0xFFE0E0E0),
//           progressColor: const Color(0xFF0F2A4F),
//         ),
//         const SizedBox(height: 8),
//         // 거리 텍스트
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text('9KM'),
//             Text('12KM'),
//           ],
//         ),
//         const SizedBox(height: 16),
//         // 지난 주 플로깅 결산
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   '$lastWeekSessions 회',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text('지난주 플로깅 횟수'),
//               ],
//             ),
//             Column(
//               children: [
//                 Text(
//                   '${lastWeekDuration ~/ 60} 시간',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text('지난주 플로깅 시간'),
//               ],
//             ),
//             Column(
//               children: [
//                 Text(
//                   '$lastWeekCalories kcal',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text('지난주 소모 칼로리'),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
