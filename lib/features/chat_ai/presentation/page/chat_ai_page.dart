import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
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
        elevation: AppConstants.elevationNone,
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
                      borderRadius: BorderRadius.circular(AppConstants.spacingXl),
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
                                width: AppConstants.spacingXl,
                                height: AppConstants.spacingXl,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: AppConstants.spacingS,
                                    height: AppConstants.spacingS,
                                    decoration: BoxDecoration(
                                      color: AppColor.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingXl),
                              Container(
                                width: AppConstants.spacingXl,
                                height: AppConstants.spacingXl,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: AppConstants.spacingS,
                                    height: AppConstants.spacingS,
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
                            width: AppConstants.radiusXl + 10,
                            height: AppConstants.borderWidthThick,
                            decoration: BoxDecoration(
                              color: AppColor.black,
                              borderRadius: BorderRadius.circular(AppConstants.elevationLow),
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
                                width: AppConstants.spacingS,
                                height: AppConstants.spacingS,
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
                          left: -AppConstants.spacingS,
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
                          right: -AppConstants.spacingS,
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
                  const SizedBox(height: AppConstants.radiusXl + 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacing40),
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: AppConstants.spacingXl,
                          height: AppConstants.spacingXl,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColor.gradientPurple, AppColor.gradientPink],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColor.white,
                            size: AppConstants.spacingM,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingS),
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
            padding: const EdgeInsets.all(AppConstants.spacingL),
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(AppConstants.opacityLow),
                  blurRadius: AppConstants.blurRadiusM,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
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
                const SizedBox(width: AppConstants.spacingS),
                Container(
                  width: AppConstants.buttonHeightS,
                  height: AppConstants.buttonHeightS,
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send,
                    color: AppColor.white,
                    size: AppConstants.spacingXl,
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
