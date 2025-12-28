import 'package:flutter/material.dart';

abstract class AppColor {
  // --- Core Colors (Sesuai Data Image) ---
  static const primary = _BrandColor.primary; // #1D2957
  static const secondary = _BrandColor.secondary; // #111832
  static const backgroundScaffold = Color(0xffF4F5FB); // #F4F5FB

  // --- UI Surfaces ---
  static const white = Colors.white;
  static const transparent = Colors.transparent;
  static const border = Color(0xFFE5E7EB); // Abu-abu muda untuk border input
  static const placeholder = Color(0xFF9CA3AF); // Abu-abu untuk hint text

  // --- Specific UI Elements (Sampling dari Gambar) ---
  // Background ungu muda pada box "Respon AI" [UC-2]
  static const aiResponseBackground = Color(0xFFEEF2FF);
  // Text ungu gelap pada box "Respon AI" [UC-2]
  static const aiResponseText = Color(0xFF3730A3);

  // Chat Bubble Sender (User) - Putih [UC-5]
  static const chatBubbleUser = Colors.white;
  // Chat Bubble Receiver (AI) - Ungu Gelap [UC-5]
  static const chatBubbleAi = Color(0xFF4338CA);

  // --- Status & Alerts ---
  // Label "Senang" (Kuning) [UC-2]
  static const statusHappyBg = Color(0xFFFEF3C7);
  static const statusHappyText = Color(0xFFB45309);

  // Label "Marah" (Merah) [UC-2]
  static const statusAngryBg = Color(0xFFFEE2E2);
  static const statusAngryText = Color(0xFFB91C1C);

  // Error Text / Border [UC-3]
  static const error = Color(0xFFEF4444);

  // --- Additional UI Colors ---
  // Welcome page arch background
  static const archBackground = Color(0xFFEFF3FD);
  // Create curhat page hint background
  static const hintBackground = Color(0xFFF3F5FE);
  // Chat AI robot color
  static const chatRobotPrimary = Color(0xFFB0C4C7);
  static const chatRobotSecondary = Color(0xFF8FA5A8);
  // Light background
  static const backgroundLight = Color(0xFFF5F5F5);
  // Grey colors
  static const grey = Colors.grey;
  static const greyLight = Color(0xFF9CA3AF);
  // Black (for consistency)
  static const black = Colors.black;
  static const black87 = Colors.black87;

  // --- Mood Colors ---
  static const moodHappyBg = Color(0xFFFFF9C4); // Kuning muda
  static const moodNeutralBg = Color(0xFFE0E0E0); // Abu-abu
  static const moodSadBg = Color(0xFFBBDEFB); // Biru muda
  static const moodAngryBg = Color(0xFFFFCDD2); // Merah muda

  // --- Gradient Colors ---
  static const gradientPurple = Color(0xFF8B5CF6);
  static const gradientPink = Color(0xFFEC4899);

  // --- Dashed Border ---
  static const dashedBorderPurple = Color(0xFF9333EA);
}

abstract class _BrandColor {
  // Primary Blue: #1D2957
  static const int _primaryValue = 0xff1D2957;
  static const MaterialColor primary = MaterialColor(_primaryValue, {
    50: Color(0xffE8EAF6),
    100: Color(0xffC5CBE9),
    200: Color(0xff9FA8DA),
    300: Color(0xff7985CB),
    400: Color(0xff5C6BC0),
    500: Color(_primaryValue),
    600: Color(0xff1A254E),
    700: Color(0xff161F43),
    800: Color(0xff121939),
    900: Color(0xff0B1026),
  });

  // Secondary Dark: #111832
  static const int _secondaryValue = 0xff111832;
  static const MaterialColor secondary = MaterialColor(_secondaryValue, {
    50: Color(0xffEBECEF),
    100: Color(0xffCDCFD6),
    200: Color(0xffABAFBB),
    300: Color(0xff8990A1),
    400: Color(0xff6F778D),
    500: Color(_secondaryValue),
    600: Color(0xff0F152D),
    700: Color(0xff0C1126),
    800: Color(0xff090D1F),
    900: Color(0xff050712),
  });
}
