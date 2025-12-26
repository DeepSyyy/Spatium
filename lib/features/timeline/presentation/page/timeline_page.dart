import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:spatium/features/timeline/presentation/widget/app_bar_timeline.dart';
import 'package:spatium/features/timeline/presentation/widget/card_timeline.dart';

class TimelinePage extends StatelessWidget {
  @Preview(name: 'Timeline Page')
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimelineAppbar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemCount: 5,
          itemBuilder: (context, index) {
            return CardCurhat();
          },
        ),
      ),
    );
  }
}
