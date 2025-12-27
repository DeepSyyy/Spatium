import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';

class SpatiumTypography {
  // Base font family
  static const String _fontFamily = 'Inter'; // Fallback ke system font
  
  // Heading Besar (misal: "Timeline Curhat", "Spatium")
  static TextStyle get h1 => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColor.secondary,   // #111832
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
}