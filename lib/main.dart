import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:toplearth/app/env/common/environment_factory.dart';
import 'package:toplearth/data/factory/storage_factory.dart';
import 'package:toplearth/main_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toplearth/firebase_options.dart';

void main() async {
  await onInitSystem();
  await onReadySystem();

  runApp(const MainApp());
}

Future<void> onInitSystem() async {
  // Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // DateTime Formatting
  await initializeDateFormatting();
  tz.initializeTimeZones();

  // Environment
  await EnvironmentFactory.onInit();

  // Storage & Database
  await StorageFactory.onInit();
}

Future<void> onReadySystem() async {
  // Storage & Database
  await StorageFactory.onReady();

  // If new download app, remove tokens
  // When token exists, isFirstRun is false
  bool isFirstRun = StorageFactory.systemProvider.getFirstRun();

  if (isFirstRun) {
    await StorageFactory.systemProvider.deallocateTokens();
    await StorageFactory.systemProvider.setFirstRun(false);
  }
}
