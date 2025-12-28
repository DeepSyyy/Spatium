import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/pages/main_navigation_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER (Tetap) ---
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Spatium',
                    style: SpatiumTypography.h1.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Get to know yourself better, trace,\nembrace and review to be better version of\nyou!',
                    style: SpatiumTypography.bodyRegular.copyWith(
                      color: AppColor.placeholder,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // --- AREA BUSUR & MOODS ---
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Background Busur
                Positioned.fill(
                  child: ClipPath(
                    clipper: ArcClipper(),
                    child: Container(
                      color: AppColor.archBackground,
                    ),
                  ),
                ),

                // 2. Mood Icons (Tersebar & Tidak Overlap)

                // --- BARIS 1 (Paling Atas) ---
                // Happy Flower (Tengah Atas)
                const _PositionedMood(
                  asset: 'happy.svg',
                  top: 0, left: 0, right: 0, size: 105 // Center
                ),
                // Angry Star (Kiri Atas)
                const _PositionedMood(
                  asset: 'angry.svg',
                  top: 45, left: 20, angle: -0.2, size: 95
                ),
                // Sad Ghost (Kanan Atas)
                const _PositionedMood(
                  asset: 'sad.svg',
                  top: 35, right: 15, angle: 0.1, size: 100
                ),

                // --- BARIS 2 (Tengah) ---
                // Neutral Square (Tengah agak ke bawah dari baris 1)
                const _PositionedMood(
                  asset: 'neutral.svg',
                  top: 140, left: 0, right: 0, angle: -0.05, size: 100 // Center
                ),
                // Angry Star (Kanan Tengah - Jauh ke kanan)
                const _PositionedMood(
                  asset: 'angry.svg',
                  top: 150, right: -10, angle: 0.2, size: 105
                ),
                // Sad Ghost (Kiri Tengah - Jauh ke kiri)
                const _PositionedMood(
                  asset: 'sad.svg',
                  top: 190, left: 10, angle: -0.1, size: 100
                ),

                // --- BARIS 3 (Bawah) ---
                // Happy Flower (Kiri Bawah - Hampir keluar layar)
                const _PositionedMood(
                  asset: 'happy.svg',
                  top: 280, left: -25, angle: -0.3, size: 100
                ),
                // Neutral Square (Kanan Bawah)
                const _PositionedMood(
                  asset: 'neutral.svg',
                  bottom: 150, right: 40, angle: 0.1, size: 95
                ),
                
                // --- BARIS 4 (Area Tombol & Paling Bawah) ---
                // Happy Flower (Tengah Bawah - Di belakang tombol)
                const _PositionedMood(
                  asset: 'happy.svg',
                  bottom: 70, left: 0, right: 0, size: 110 // Center
                ),
                
                // Dekorasi Pojok Bawah (Potongan)
                // Pojok Kiri Bawah
                const _PositionedMood(
                  asset: 'neutral.svg',
                  bottom: -20, left: -20, angle: 0.1, size: 100
                ),
                // Pojok Kanan Bawah
                const _PositionedMood(
                  asset: 'angry.svg',
                  bottom: -15, right: -25, angle: -0.2, size: 115
                ),

                // 3. Tombol
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const MainNavigationPage(),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Mulai Curhat!',
                        style: SpatiumTypography.button.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- HELPER & CLIPPER (Tetap Sama) ---

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 50.0; 
    path.moveTo(0, curveHeight);
    path.quadraticBezierTo(
      size.width / 2, 0, 
      size.width, curveHeight 
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _PositionedMood extends StatelessWidget {
  final String asset;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double angle; 
  final double size;

  const _PositionedMood({
    required this.asset,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.angle = 0.0,
    this.size = 90.0,
  });

  @override
  Widget build(BuildContext context) {
    if (left == 0 && right == 0) {
      return Positioned(
        top: top,
        bottom: bottom,
        left: 0,
        right: 0,
        child: Center(
          child: Transform.rotate(
            angle: angle,
            child: SvgPicture.asset(
              'assets/svg/$asset',
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: SvgPicture.asset(
          'assets/svg/$asset',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}