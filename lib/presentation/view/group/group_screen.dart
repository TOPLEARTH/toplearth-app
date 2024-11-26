import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/app/config/font_system.dart';
import 'package:toplearth/core/view/base_screen.dart';
import 'package:toplearth/domain/entity/group/member_state.dart';
import 'package:toplearth/presentation/view_model/group/group_view_model.dart';
import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';

// 뷰모델 익히기용
class GroupScreen extends BaseScreen<GroupViewModel> {
  const GroupScreen({super.key});

  @override
  Color get unSafeAreaColor => ColorSystem.blue;

  @override
  bool get setTopOuterSafeArea => true;

  @override
  bool get setBottomOuterSafeArea => false;

  @override
  bool get extendBodyBehindAppBar => false; // SafeArea를 넘지 않도록 설정

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const DefaultAppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //그룹 정보
            _buildGroupInfoSection(),
            const SizedBox(height: 16),
            //승률 및 팀원 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMemberList(),
                _buildCircularProgressBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfoSection() {
    return  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 추가
            children: [
              const Text("그룹 정보", style: FontSystem.H3),
              Text("그룹 탈퇴하기",
                  style: FontSystem.Sub1.copyWith(color: ColorSystem.grey)),
            ],
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow("그룹명 🌏", viewModel.teamInfoState.teamName),
                  _buildInfoRow("그룹코드 🌿", viewModel.teamInfoState.teamCode),
                ],
              ),
            ),
          ),
        ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 추가
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: FontSystem.Sub2),
        const SizedBox(height: 4),
        Text(value, style: FontSystem.Sub2.copyWith(color: ColorSystem.grey)),
      ],
    );
  }

  Widget _buildMemberList() {
    // Get the team members from the ViewModel

    if (viewModel.teamInfoState.teamMemebers.isEmpty) {
      return const SizedBox
          .shrink(); // Return an empty widget if no members exist
    }

    return Obx(
      () => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: 242,
          width: 160,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('팀원', style: FontSystem.H2),
                const SizedBox(height: 12),
                // Render each member row
                ...viewModel.teamInfoState.teamMemebers
                    .map((member) => _buildMemberRow(member))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(MemberState member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            member.name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          if (member.role == 'LEADER')
            const Icon(Icons.abc)
          else if (member.role == 'MEMBER')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '팀장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularProgressBar() {
    double winRate = viewModel.teamInfoState.matchCnt > 0
        ? (viewModel.teamInfoState.winCnt / viewModel.teamInfoState.matchCnt)
        : 0.0;
    double winRate100 = viewModel.teamInfoState.matchCnt > 0
        ? (viewModel.teamInfoState.winCnt / viewModel.teamInfoState.matchCnt) *
            100
        : 0.0;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("팀 승률", style: FontSystem.H3),
            const SizedBox(height: 47),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: winRate,
                  strokeWidth: 20,
                  strokeAlign: 3,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(ColorSystem.main),
                  backgroundColor: ColorSystem.grey[300],
                ),
                Text("$winRate100%", style: FontSystem.H3),
              ],
            ),
            const SizedBox(height: 47),
            Text(
              "${viewModel.teamInfoState.matchCnt}개의 대결 중\n${viewModel.teamInfoState.winCnt}경기를 이겼어요!",
              style: FontSystem.Sub2.copyWith(color: ColorSystem.grey),
            ),
          ],
        ),
      ),
    );
  }

  // List<String> _getTeamMemberNames(TeamInfo teamInfo) {
  //   return teamInfo.teamSelect['2024-12']?.distances
  //           .map((member) => member.name)
  //           .toList() ??
  //       [];
  // }

//기존 그룹 화면

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:toplearth/app/config/color_system.dart';
// import 'package:toplearth/app/config/font_system.dart';
// import 'package:toplearth/core/view/base_screen.dart';
// import 'package:toplearth/presentation/view_model/group/group_view_model.dart';
// import 'package:toplearth/presentation/widget/appbar/default_app_bar.dart';
//
// class GroupScreen extends BaseScreen<GroupViewModel> {
//   const GroupScreen({super.key});
//
//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return const DefaultAppBar();
//   }
//
//   @override
//   Widget buildBody(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildGroupInfoSection(context),
//             const SizedBox(height: 16),
//             _buildTeamDetailsSection(context),
//             const SizedBox(height: 16),
//             _buildProgressBarSection(context),
//             const SizedBox(height: 16),
//             _buildTrashReportSection(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGroupInfoSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _buildCardDecoration(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildInfoColumn("그룹명", "얼쑤얼쑤 🌏"),
//           _buildInfoColumn("그룹코드", "1213"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoColumn(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: FontSystem.Sub2.copyWith(color: ColorSystem.grey)),
//         const SizedBox(height: 4),
//         Text(value, style: FontSystem.H3.copyWith(fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
//
//   Widget _buildTeamDetailsSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _buildCardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("팀원", style: FontSystem.H3.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           _buildTeamMembersList(),
//           const SizedBox(height: 16),
//           Text("팀 승률", style: FontSystem.H3.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           _buildCircularProgressBar(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamMembersList() {
//     final members = [
//       {"name": "김동국", "badge": "🏆"},
//       {"name": "김신공", "badge": "ME"},
//       {"name": "김무로", "badge": "🚀"},
//       {"name": "김경희", "badge": "🔥"},
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: members.map((member) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(member['name']!, style: FontSystem.Sub1),
//               Text(member['badge']!, style: FontSystem.Sub1),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildCircularProgressBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CircularProgressIndicator(
//                 value: 0.4,
//                 strokeWidth: 10,
//                 valueColor: AlwaysStoppedAnimation<Color>(ColorSystem.main),
//                 backgroundColor: ColorSystem.grey[300],
//               ),
//               Text("40%", style: FontSystem.H3),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             "15개의 대결 중 6경기를 이겼어요!",
//             style: FontSystem.Sub2.copyWith(color: ColorSystem.grey),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProgressBarSection(BuildContext context) {
//     final records = [
//       {"name": "김무로", "distance": 20.0},
//       {"name": "김동국", "distance": 18.2},
//       {"name": "김신공", "distance": 14.0},
//       {"name": "김경희", "distance": 2.0},
//     ];
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _buildCardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("2024.11", style: FontSystem.H3.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           ...records.map((record) => _buildProgressRow(record)).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressRow(Map<String, dynamic> record) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(record['name']!, style: FontSystem.Sub1),
//             Text("${record['distance']}km", style: FontSystem.Sub1),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: record['distance'] / 20,
//           color: ColorSystem.main,
//           backgroundColor: ColorSystem.grey[300],
//         ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }
//
//   Widget _buildTrashReportSection(BuildContext context) {
//     final categories = ["플라스틱", "캔", "유리", "종이", "기타"];
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _buildCardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("쓰레기 리포트", style: FontSystem.H3.copyWith(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: categories.map((category) {
//               return Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: ColorSystem.main,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Text(
//                     category,
//                     style: FontSystem.Sub1.copyWith(color: Colors.white),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   BoxDecoration _buildCardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           blurRadius: 6,
//           spreadRadius: 2,
//         ),
//       ],
//     );
//   }
// }
//
// class TrashCategory {
//   final String category;
//   final int value;
//
//   TrashCategory(this.category, this.value);
// }
}
