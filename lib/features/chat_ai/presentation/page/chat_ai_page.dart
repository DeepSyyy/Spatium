import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';

class ChatAIPage extends StatelessWidget {
  const ChatAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.chatBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chat AI', style: SpatiumTypography.chatTitle),
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
                      color: AppColor.robotColor,
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
                                decoration: const BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColor.textPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColor.textPrimary,
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
                              color: AppColor.textPrimary,
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
                                decoration: const BoxDecoration(
                                  color: AppColor.robotDark,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 10,
                                color: AppColor.robotDark,
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
                              color: AppColor.robotDark,
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
                              color: AppColor.robotDark,
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
                            gradient: const LinearGradient(
                              colors: [
                                AppColor.gradientPurple,
                                AppColor.gradientPink,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColor.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Halo, apa yang ingin kamu ceritakkan hari ini?',
                            style: SpatiumTypography.chatMessage,
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
                  color: Colors.black.withOpacity(0.05),
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
                      color: AppColor.chatBackground,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tulis pesanmu ...',
                        hintStyle: SpatiumTypography.chatHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColor.sendButtonBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
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
