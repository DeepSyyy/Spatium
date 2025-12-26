import 'package:flutter/material.dart';

class TimelineAppbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TimelineAppbar> createState() => _TimelineAppbarState();
}

class _TimelineAppbarState extends State<TimelineAppbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Expanded(
          child: Text(
            'Timeline Curhat',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [Icon(Icons.add, size: 20), Text("Curhat Baru")],
          ),
        ),
      ],
    );
  }
}
