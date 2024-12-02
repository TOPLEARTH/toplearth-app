// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:toplearth/app/config/font_system.dart';
// import 'package:toplearth/core/view/base_widget.dart';
// import 'package:toplearth/presentation/view_model/matching/matching_view_model.dart';
//
// class RecentPloggingView extends BaseWidget<MatchingGroupViewModel> {
//   const RecentPloggingView({Key? key}) : super(key: key);
//
//   @override
//   Widget buildView(BuildContext context) {
//     return Obx(() {
//       final ploggingList = viewModel.recentPloggingList;
//
//       print('RecentPloggingView: ploggingList: $ploggingList');
//
//       // 플로깅 데이터가 없을 때
//       if (ploggingList.isEmpty) {
//         return Center(
//           child: Text(
//             '최근 플로깅 기록이 없습니다.',
//             style: FontSystem.H3.copyWith(color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }
//
//       // 플로깅 데이터가 있을 때
//       return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: ploggingList.length,
//         itemBuilder: (context, index) {
//           final plogging = ploggingList[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 팀 이름
//                   Text(
//                     plogging.recentMatchingInfo.teamName,
//                     style: FontSystem.H2.copyWith(color: Colors.black),
//                   ),
//                   const SizedBox(height: 8),
//
//                   // 거리와 시간 정보
//                   Text('거리: ${plogging.distance}m | 시간: ${plogging.duration}초'),
//                   const SizedBox(height: 8),
//
//                   // 쓰레기 수량
//                   Text('쓰레기 수량: ${plogging.trashCnt}'),
//                   const SizedBox(height: 8),
//
//                   // 첫 번째 이미지 또는 기본 텍스트
//                   plogging.ploggingImageList.isNotEmpty
//                       ? Image.network(
//                     plogging.ploggingImageList.first.imageUrl,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   )
//                       : Text(
//                     '이미지 없음',
//                     style: FontSystem.H4.copyWith(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
