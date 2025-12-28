import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';

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
    height: AppConstants.lineHeight15, // Line height agar nyaman dibaca
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

  // --- Additional Text Styles ---

  // Large heading for page titles (28px)
  static TextStyle get h1Large => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
    letterSpacing: -0.5,
  );

  // Medium heading (20px)
  static TextStyle get h2 => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
  );

  // AppBar title style (18px)
  static TextStyle get appBarTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.black,
  );

  // Button text large (16px)
  static TextStyle get buttonLarge => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );

  // Body text with grey color (15px)
  static TextStyle get bodyGrey => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.placeholder,
    height: AppConstants.lineHeight15,
  );

  // Body text standard size (16px)
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.grey,
  );

  // Small chat text (12px)
  static TextStyle get chatSmall => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.black87,
  );

  // Hint text (14px)
  static TextStyle get hint => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.grey,
  );

  // Page title standard (20px)
  static TextStyle get pageTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColor.black,
  );

  // Large text (24px, bold)
  static TextStyle get textLarge => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColor.black,
  );

  // Welcome page title (28px, bold, secondary color)
  static TextStyle get welcomeTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
    letterSpacing: -0.5,
  );

  // Welcome page subtitle/description (15px, placeholder color)
  static TextStyle get welcomeSubtitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColor.placeholder,
    height: AppConstants.lineHeight15,
  );

  // Button text with custom size (16px, semibold, white)
  static TextStyle get buttonText => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );

  // Label text - semibold for form labels
  static TextStyle get labelSemiBold => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColor.secondary,
  );

  // Small button text (13px, semibold, white)
  static TextStyle get buttonSmall => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );

  // Status/mood label text (12px, semibold)
  static TextStyle get statusLabel => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColor.statusHappyText,
  );

  // AI Response title (14px, semibold, AI response text color)
  static TextStyle get aiResponseTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColor.aiResponseText,
  );

  // AI Response body (13px, regular, AI response text color)
  static TextStyle get aiResponseBody => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColor.aiResponseText,
  );

  // Curhat failed page title (20px, bold, secondary color)
  static TextStyle get failedTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
  );

  // Timeline title for small screens (20px)
  static TextStyle get timelineTitleSmall => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColor.secondary,
    letterSpacing: -0.5,
  );

  // Bottom nav label (12px, medium weight)
  static TextStyle get navLabel => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.greyLight,
  );

  // Bottom nav label selected (12px, medium weight, black)
  static TextStyle get navLabelSelected => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.black,
  );
}
