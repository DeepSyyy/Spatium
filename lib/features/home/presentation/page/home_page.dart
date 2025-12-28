import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Text('Home Page', style: SpatiumTypography.bodyMedium),
      ),
    );
  }
}
