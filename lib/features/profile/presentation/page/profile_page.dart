import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Profil', style: SpatiumTypography.appBarTitle),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Profile Page',
          style: SpatiumTypography.pageTitle,
        ),
      ),
    );
  }
}
