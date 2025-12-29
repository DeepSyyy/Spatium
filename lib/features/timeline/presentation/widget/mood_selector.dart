import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class MoodSelector extends StatefulWidget {
  final String selectedMood;
  final Function(String) onMoodChanged;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodChanged,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  final List<MoodData> _moods = [
    MoodData(
      name: 'Senang',
      svgPath: 'assets/svg/happy.svg',
      backgroundColor: AppColor.moodHappyBg,
    ),
    MoodData(
      name: 'Biasa',
      svgPath: 'assets/svg/neutral.svg',
      backgroundColor: AppColor.moodNeutralBg,
    ),
    MoodData(
      name: 'Sedih',
      svgPath: 'assets/svg/sad.svg',
      backgroundColor: AppColor.moodSadBg,
    ),
    MoodData(
      name: 'Marah',
      svgPath: 'assets/svg/angry.svg',
      backgroundColor: AppColor.moodAngryBg,
    ),
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = _moods.indexWhere((mood) => mood.name == widget.selectedMood);
    if (_currentIndex == -1) _currentIndex = 0; // Default to first mood (Senang)
  }

  void _previousMood() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _moods.length) % _moods.length;
      widget.onMoodChanged(_moods[_currentIndex].name);
    });
  }

  void _nextMood() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _moods.length;
      widget.onMoodChanged(_moods[_currentIndex].name);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan _currentIndex valid
    if (_currentIndex < 0 || _currentIndex >= _moods.length) {
      _currentIndex = 0;
    }
    
    final currentMood = _moods[_currentIndex];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        IconButton(
          onPressed: _previousMood,
          icon: const Icon(Icons.chevron_left, size: AppConstants.iconL),
          color: AppColor.secondary,
        ),
        const SizedBox(width: AppConstants.spacingM),
        
        // Mood Display dengan border putus-putus (rasio 1:1)
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: DashedBorderPainter(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = constraints.maxWidth;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Lingkaran background PENUH dengan warna mood
                            Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                color: currentMood.backgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Content di dalam lingkaran
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SVG Mood Icon
                                SvgPicture.asset(
                                  currentMood.svgPath,
                                  width: size * 0.45,
                                  height: size * 0.45,
                                ),
                                const SizedBox(height: AppConstants.iconXs),
                                // Mood Name di dalam lingkaran
                                Text(
                                  currentMood.name,
                                  style: SpatiumTypography.h3,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingM),
        
        // Next Button
        IconButton(
          onPressed: _nextMood,
          icon: const Icon(Icons.chevron_right, size: AppConstants.iconL),
          color: AppColor.secondary,
        ),
      ],
    );
  }
}

class MoodData {
  final String name;
  final String svgPath;
  final Color backgroundColor;

  MoodData({
    required this.name,
    required this.svgPath,
    required this.backgroundColor,
  });
}

// Custom painter untuk border putus-putus ungu
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.dashedBorderPurple
      ..strokeWidth = AppConstants.borderWidthMedium
      ..style = PaintingStyle.stroke;

    const dashWidth = AppConstants.dashWidth;
    const dashSpace = AppConstants.dashSpace;
    const radius = AppConstants.spacingL;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ));

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(start, end),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
