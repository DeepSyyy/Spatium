import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';

class ChatAIPage extends StatelessWidget {
  const ChatAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chat AI',
          style: SpatiumTypography.appBarTitle,
        ),
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColor.chatRobotPrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Robot eyes
                        Positioned(
                          top: 35,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColor.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColor.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Mouth
                        Positioned(
                          top: 65,
                          child: Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColor.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Antenna
                        Positioned(
                          top: -5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColor.chatRobotSecondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 10,
                                color: AppColor.chatRobotSecondary,
                              ),
                            ],
                          ),
                        ),
                        // Ears
                        Positioned(
                          left: -8,
                          top: 45,
                          child: Container(
                            width: 15,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColor.chatRobotSecondary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -8,
                          top: 45,
                          child: Container(
                            width: 15,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColor.chatRobotSecondary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColor.gradientPurple, AppColor.gradientPink],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColor.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Halo, apa yang ingin kamu ceritakkan hari ini?',
                            style: SpatiumTypography.chatSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundLight,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tulis pesanmu ...',
                        hintStyle: SpatiumTypography.hint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send,
                    color: AppColor.white,
                    size: 20,
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
