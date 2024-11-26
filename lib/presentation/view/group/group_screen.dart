import 'package:flutter/material.dart';
import 'package:toplearth/app/config/color_system.dart';
import 'package:toplearth/core/view/base_widget.dart';
import 'package:toplearth/domain/entity/group/member_state.dart';
import 'package:toplearth/domain/entity/group/label_state.dart';
import 'package:toplearth/domain/entity/group/team_info_state.dart';
import 'package:toplearth/presentation/view_model/group/group_view_model.dart';

// 뷰모델 익히기용
class GroupScreen extends BaseWidget<GroupViewModel> {
  const GroupScreen({super.key});


  @override
  Widget buildView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupInfoSection(),
            const SizedBox(height: 16),
            _buildMembersSection(),
            const SizedBox(height: 16),
            _buildLabelsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfoSection() {
    final teamInfo = viewModel.teamInfoState;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("그룹명: ${teamInfo.teamName}", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text("그룹코드: ${teamInfo.teamCode}", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    final members = viewModel.currentMonthData?.members ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("팀원 목록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...members.map((member) => _buildMemberRow(member)).toList(),
        ],
      ),
    );
  }

  Widget _buildMemberRow(MemberState member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(member.name, style: TextStyle(fontSize: 16)),
          Text("${member.distance}km", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLabelsSection() {
    final labels = viewModel.currentMonthData?.labels ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("수거된 쓰레기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...labels.map((label) => _buildLabelRow(label)).toList(),
        ],
      ),
    );
  }

  Widget _buildLabelRow(LabelState label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.label, style: TextStyle(fontSize: 16)),
          Text("${label.count}개", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          spreadRadius: 2,
        ),
      ],
    );
  }
}

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
