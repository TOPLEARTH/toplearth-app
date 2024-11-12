import 'package:toplearth/app/env/common/environment.dart';
import 'package:toplearth/app/env/dev/dev_environment.dart';

abstract class EnvironmentFactory {
  static Environment? _environment;

  static Environment get environment => EnvironmentFactory._environment!;

  static Future<void> onInit() async {
    _environment = DevEnvironment();
  }
}
