import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Screens/Pages/notes_screen.dart';
import 'package:money_mate/Screens/Pages/settings_screen.dart';
import 'package:money_mate/controllers/admob_service.dart';
import 'package:money_mate/controllers/user_controller.dart';

import 'Components/bottom_bar.dart';
import 'Screens/OnBoarding/onboarding_screen.dart';
import 'Screens/Pages/home_screen.dart';
import 'controllers/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initialize();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(UserController());
  Get.put<LocalNotificationsController>(LocalNotificationsController());
  var storage = GetStorage();
  var uMail = storage.read('email');
  if (kDebugMode) {
    print(uMail);
  }
  runApp(GetMaterialApp(
      title: 'On Boarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomePage(),
        // '/analytics': (context) => MyHomePage(),
        '/notes': (context) => const NotesPage(),
        '/settings': (context) => SettingsPage(),
      },
      home: uMail == null
          ? const OnBoardingPage()
          : const BottomHomeBar(index: 0)));
}
