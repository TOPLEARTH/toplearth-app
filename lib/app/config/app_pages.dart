import 'package:get/get.dart';
import 'package:toplearth/app/config/app_routes.dart';
import 'package:toplearth/app/middleware/login_middleware.dart';
import 'package:toplearth/app/middleware/on_boarding_middleware.dart';
import 'package:toplearth/presentation/view/legacy/legacy_screen.dart';
import 'package:toplearth/presentation/view/login/login_screen.dart';
import 'package:toplearth/presentation/view/matching/matching_group_create_complete_screen.dart';
import 'package:toplearth/presentation/view/matching/matching_group_create_screen.dart';
import 'package:toplearth/presentation/view/matching/matching_group_search_screen.dart';
import 'package:toplearth/presentation/view/on_boarding/on_boarding_screen.dart';
import 'package:toplearth/presentation/view/plogging/plogging_labeling_screen.dart';
import 'package:toplearth/presentation/view/plogging/plogging_screen.dart';
import 'package:toplearth/presentation/view/plogging/plogging_share_screen.dart';
import 'package:toplearth/presentation/view/plogging/recent_plogging_screen.dart';
import 'package:toplearth/presentation/view/report/report_screen.dart';
import 'package:toplearth/presentation/view/store/store_detail_screen.dart';
import 'package:toplearth/presentation/view_model/legacy/legacy_binding.dart';
import 'package:toplearth/presentation/view_model/login/login_binding.dart';
import 'package:toplearth/presentation/view_model/matching_group_complete/matching_group_create_complete_binding.dart';
import 'package:toplearth/presentation/view_model/matching_group_create/matching_group_create_binding.dart';
import 'package:toplearth/presentation/view_model/matching_group_search/matching_group_search_binding.dart';
import 'package:toplearth/presentation/view_model/plogging/plogging_binding.dart';
import 'package:toplearth/presentation/view_model/root/root_binding.dart';
import 'package:toplearth/presentation/view_model/store/store_binding.dart';
import 'package:toplearth/test_code/image_upload_binding.dart';
import 'package:toplearth/test_code/test_code_screen.dart';
import 'package:toplearth/presentation/view/root/root_screen.dart';
import 'package:toplearth/test_code/test_code_screen.dart';

abstract class AppPages {
  static List<GetPage> data = [
    GetPage(
      name: AppRoutes.ON_BOARDING,
      page: () => const OnBoardingScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.ROOT,
      page: () => const RootScreen(),
      bindings: [
        RootBinding(),
      ],
      middlewares: [
        OnBoardingMiddleware(),
        LoginMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.LEGACY,
      page: () => const LegacyScreen(),
      binding: LegacyBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_CREATE,
      page: () => const MatchingGroupCreateScreen(),
      binding: MatchingGroupCreateBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_SEARCH,
      page: () => const MatchingGroupSearchScreen(),
      binding: MatchingGroupSearchBinding(),
    ),
    GetPage(
      name: AppRoutes.GROUP_CREATE_COMPLETE,
      page: () => const MatchingGroupCreateCompleteScreen(),
      binding: MatchingGroupCreateCompleteBinding(),
    ),
    GetPage(
      name: AppRoutes.PLOGGING,
      page: () => PloggingScreen(),
      binding: PloggingBinding(),
    ),
    GetPage(
      name: AppRoutes.PLOGGING_LABELING,
      page: () => PloggingLabelingScreen(),
      binding: PloggingBinding(),
    ),
    GetPage(
      name: AppRoutes.STORE_DETAIL,
      page: () => StoreDetailScreen(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.PLOGGING_SHARE,
      page: () => PloggingShareScreen(),
      binding: PloggingBinding(),
    ),
    GetPage(
        name: AppRoutes.PLOGGING_RECENT,
        page: () => RecentPloggingScreen(),
        binding: PloggingBinding()),
    GetPage(
      name: AppRoutes.REPORT,
      page: () => ReportScreen(),
      binding: PloggingBinding(),
    ),
  ];
}
