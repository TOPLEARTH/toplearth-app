// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:toplearth/app/config/color_system.dart';
// import 'package:toplearth/core/view/base_screen.dart';
// import 'package:toplearth/presentation/view/app_setting/widget/toggle_section_view.dart';
// import 'package:toplearth/presentation/view_model/app_setting/app_setting_view_model.dart';
// import 'package:toplearth/presentation/widget/appbar/custom_back_app_bar.dart';
// import 'package:toplearth/presentation/widget/line/infinity_horizon_line.dart';
// // import 'package:hyeyum_modeul/app/config/color_system.dart';
// // import 'package:hyeyum_modeul/core/view/base_screen.dart';
// // import 'package:hyeyum_modeul/presentation/view/app_setting/widget/toggle_section_view.dart';
// // import 'package:hyeyum_modeul/presentation/view_model/app_setting/app_setting_view_model.dart';
// // import 'package:hyeyum_modeul/presentation/widget/appbar/custom_back_app_bar.dart';
// // import 'package:hyeyum_modeul/presentation/widget/line/infinity_horizon_line.dart';
//
// class AppSettingScreen extends BaseScreen<AppSettingViewModel> {
//   const AppSettingScreen({super.key});
//
//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return const PreferredSize(
//       preferredSize: Size.fromHeight(56),
//       child: CustomBackAppBar(
//         title: '앱 설정',
//       ),
//     );
//   }
//
//   @override
//   Widget buildBody(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           Obx(
//             () => ToggleSectionView(
//               title: "혜윰터 알림 수신",
//               content: "혜윰터에서 답변이 작성되면 알림을 받습니다",
//               isEnable: viewModel.enableHyeyumteoNotification,
//               onToggle: viewModel.toggleHyeyumteoNotification,
//             ),
//           ),
//           InfinityHorizonLine(
//             gap: 1,
//             color: ColorSystem.neutral.shade200,
//           ),
//           Obx(
//             () => ToggleSectionView(
//               title: "모들락 알림 수신",
//               content: "모들락이 정리가 끝나면 알림을 받습니다",
//               isEnable: viewModel.enableToplearthNotification,
//             ),
//           ),
//           InfinityHorizonLine(
//             gap: 1,
//             color: ColorSystem.neutral.shade200,
//           ),
//           Obx(
//             () => ToggleSectionView(
//               title: "마케팅 알림 수신",
//               content: "다양한 이벤트 및 소식을 받습니다",
//               isEnable: viewModel.enableMarketNotification,
//               onToggle: viewModel.toggleMarketNotification,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
