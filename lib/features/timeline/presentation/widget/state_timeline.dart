import 'package:flutter/material.dart';

class TimelineError extends StatelessWidget {
  const TimelineError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(radius: 120),
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
        children: [
          CircleAvatar(radius: 120),
          Text('Your Mood Today?'),
          Text('Ada cerita apa hari ini?'),
          Text("Ceritain dong..."),
        ],
      ),
    );
  }
}
