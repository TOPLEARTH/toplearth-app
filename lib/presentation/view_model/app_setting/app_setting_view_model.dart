import 'package:get/get.dart';

class AppSettingViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* Static Fields ---------------------------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* DI Fields -------------------------------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* Private Fields --------------------------------------- */
  /* ------------------------------------------------------ */
  late final RxBool _enableToplearthNotification;
  late final RxBool _enableMarketNotification;

  /* ------------------------------------------------------ */
  /* Public Fields ---------------------------------------- */
  /* ------------------------------------------------------ */
  bool get enableToplearthNotification => _enableToplearthNotification.value;
  bool get enableMarketNotification => _enableMarketNotification.value;

  /* ------------------------------------------------------ */
  /* Method ----------------------------------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();

    _enableToplearthNotification = false.obs;
    _enableMarketNotification = false.obs;
  }

  void toggleToplearthNotification(bool value) {
    _enableToplearthNotification.value = value;
  }

  void toggleMarketNotification(bool value) {
    _enableMarketNotification.value = value;
  }
}
