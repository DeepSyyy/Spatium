import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:spatium/features/auth/presentation/page/register_page.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/button_app.dart';

class AuthPage extends StatelessWidget {
  @Preview(name: 'Auth Page')
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppConstants.spacingXl, top: AppConstants.spacing32, right: AppConstants.spacingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 23),
                Text(
                  "Spatium",
                  style: SpatiumTypography.textLarge,
                ),
                const SizedBox(height: AppConstants.spacingL),
                Text(
                  "Get to know yourself better, trace, embrace and review to be better version of you!",
                  style: SpatiumTypography.bodyMedium,
                ),
                const SizedBox(height: AppConstants.spacingL),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: Image.asset(
                    'assets/images/auth_illustration.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: AppConstants.spacing40,
                  left: AppConstants.spacingXl,
                  right: AppConstants.spacingXl,
                  child: ButtonApp(
                    text: 'Mulai Curhat',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
