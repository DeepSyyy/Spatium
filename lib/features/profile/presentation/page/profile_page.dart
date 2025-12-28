import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Text('Profile Page', style: SpatiumTypography.bodyMedium),
      ),
    );
  }
}
