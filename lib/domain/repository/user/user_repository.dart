
import 'package:toplearth/core/wrapper/state_wrapper.dart';
import 'package:toplearth/domain/entity/user/boot_strap_state.dart';
import 'package:toplearth/domain/entity/user/user_state.dart';

abstract class UserRepository {
  /* ------------------------------------------------------------ */
  /* --------------------------- Read --------------------------- */
  /* ------------------------------------------------------------ */
  // Future<UserState> readUserState();
  Future<StateWrapper<BootstrapState>> readBootStrapData();

/* ------------------------------------------------------------ */
/* -------------------------- Update -------------------------- */
/* ------------------------------------------------------------ */

}
