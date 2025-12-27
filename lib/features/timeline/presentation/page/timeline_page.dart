import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:spatium/features/timeline/presentation/widget/card_timeline.dart';
import 'package:spatium/features/timeline/presentation/widget/state_timeline.dart';

class TimelinePage extends StatelessWidget {
  @Preview(name: 'Timeline Page')
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return TimelineError();
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Timeline Curhat',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 20),
            label: const Text("Curhat Baru"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF6C5CE7,
              ), // Warna ungu sesuai desain
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
