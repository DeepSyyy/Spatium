import 'package:flutter/material.dart';
import 'package:spatium/styles/typography.dart';

class TimelineError extends StatelessWidget {
  const TimelineError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sad.png', width: 200, height: 200),
            const SizedBox(height: 16),
            Text(
              'Tidak Dapat memuat Timeline',
              style: SpatiumTypography.h3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineNull extends StatelessWidget {
  const TimelineNull({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/happy.png', width: 200, height: 200),
            const SizedBox(height: 16),
            Text(
              'Belum ada curhatan',
              style: SpatiumTypography.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ada cerita apa hari ini?',
              style: SpatiumTypography.bodyRegular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Ceritain dong...',
              style: SpatiumTypography.bodyRegular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
