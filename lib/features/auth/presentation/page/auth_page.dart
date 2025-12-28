import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';

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
            padding: const EdgeInsets.only(left: 20.0, top: 32.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 23),
                Text(
                  "Spatium",
                  style: SpatiumTypography.textLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Get to know yourself better, trace, embrace and review to be better version of you!",
                  style: SpatiumTypography.bodyMedium,
                ),
                const SizedBox(height: 16),
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
                  bottom: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 114,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      "Mulai Curhat",
                      style: SpatiumTypography.button,
                    ),
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
