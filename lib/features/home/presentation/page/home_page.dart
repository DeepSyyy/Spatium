import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Home', style: SpatiumTypography.appBarTitle),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        elevation: AppConstants.elevationNone,
      ),
      body: Center(
        child: Text(
          'Home Page',
          style: SpatiumTypography.pageTitle,
        ),
      ),
    );
  }
}
