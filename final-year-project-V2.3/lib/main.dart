import 'package:finalyear/SplashScreen.dart';
import 'package:finalyear/home_screen.dart';
import 'package:finalyear/teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'LoginPage.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final storage = GetStorage();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(
        "restrat user role---------------${storage.read("role").toString()}");
    return GetMaterialApp(
      title: 'Final Year',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(

        ),
        primarySwatch: Colors.blue,
      ),
      home: storage.read("role") == "admin"
          ? const HomeScreen()
          : storage.read("role") == "teacher"
              ? const teacher_class()
              : const SignInScreen(),
    );
  }
}
