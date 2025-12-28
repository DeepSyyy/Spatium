import 'package:flutter/material.dart';
import 'package:spatium/features/auth/presentation/page/splash_screen_page.dart';
import 'package:spatium/styles/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spatium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.black),
      ),
      home: const SplashScreenPage(),
    );
  }
}
