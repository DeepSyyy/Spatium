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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 8.0,
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: 5,
            itemBuilder: (context, index) {
              return const CardCurhat();
            },
          ),
        ),
      ),
    );
  }
}
