import 'package:flutter/material.dart';
import 'colors.dart';

class SpatiumTypography {
  // Base font family
  static const String _fontFamily = 'Inter'; // Fallback ke system font

  // Heading Besar (misal: "Timeline Curhat", "Spatium")
  static TextStyle get h1 => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColor.secondary, // #111832
    letterSpacing: -0.5,
  );

  // Heading Sedang (misal: Nama User "Anonymous")
  static TextStyle get h3 => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: AppColor.secondary,
  );

  // Heading Kecil / Button Text
  static TextStyle get button => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColor.white,
  );

  // Body Text (Isi curhatan)
  static TextStyle get bodyRegular => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColor.secondary,
    height: 1.5, // Line height agar nyaman dibaca
  );

  // Small Text (Timestamp "2 Jam lalu", Label)
  static TextStyle get small => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.placeholder, // Grey
  );

  // Text di dalam Input (Hint/Isi)
  static TextStyle get input => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.secondary,
  );

  // Welcome Page Title (Large)
  static TextStyle get welcomeTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
  );

  // Welcome Page Subtitle
  static TextStyle get welcomeSubtitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.placeholder,
    height: 1.5,
  );

  // Chat AI Title
  static TextStyle get chatTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  // Chat AI Message Text
  static TextStyle get chatMessage => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.black87,
  );

  // Chat AI Hint Text
  static TextStyle get chatHint => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.textGrey,
  );

  // AppBar Title
  static TextStyle get appBarTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  // Body Medium (untuk halaman simple)
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColor.secondary,
  );

  // Body with Grey Color
  static TextStyle get bodyGrey => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.textGrey,
  );

  // Button Large
  static TextStyle get buttonLarge => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );

  // Auth Page Title
  static TextStyle get authTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
  );
}
