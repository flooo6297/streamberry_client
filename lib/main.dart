import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streamberry_client/src/app.dart';

void main() async {
  timeDilation = 1.0;
  await Hive.initFlutter();
  await Hive.openBox<Map<dynamic, dynamic>>('cached_images');

  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}
