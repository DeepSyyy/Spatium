import 'package:flutter/material.dart';

class TimelineError extends StatelessWidget {
  const TimelineError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/sad.png', width: 240, height: 240),
          Text('Tidak Dapat memuat Timeline'),
        ],
      ),
    );
  }
}

class TimelineNull extends StatelessWidget {
  const TimelineNull({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/happy.png', width: 240, height: 240),
          Text('Belum ada curhatan'),
          const SizedBox(height: 8),
          Text('Ada cerita apa hari ini?'),
          Text("Ceritain dong..."),
        ],
      ),
    );
  }
}
