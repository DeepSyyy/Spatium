import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class AuthPage extends StatelessWidget {
  @Preview(name: 'Auth Page')
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Get to know yourself better, trace, embrace and review to be better version of you!",

                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 114,
                        vertical: 16,
                      ),
                    ),
                    child: const Text("Mulai Curhat"),
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
