import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class CardCurhat extends StatelessWidget {
  const CardCurhat({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04;
    
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppConstants.opacityLow),
            blurRadius: AppConstants.blurRadiusS,
            offset: const Offset(0, AppConstants.elevationLow),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: AppConstants.spacingXl,
                backgroundColor: AppColor.border,
                child: Icon(Icons.person, color: AppColor.placeholder),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Username',
                            style: SpatiumTypography.h3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingS,
                            vertical: AppConstants.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.statusHappyBg,
                            border: Border.all(
                              color: AppColor.statusHappyText.withOpacity(AppConstants.opacityHigh),
                              width: AppConstants.borderWidthThin,
                            ),
                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: AppConstants.avatarS,
                                backgroundColor: AppColor.statusHappyText,
                              ),
                              const SizedBox(width: AppConstants.spacingXs),
                              Text(
                                'Senang',
                                style: SpatiumTypography.statusLabel.copyWith(
                                  color: AppColor.statusHappyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2 Jam yang lalu',
                      style: SpatiumTypography.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: SpatiumTypography.bodyRegular,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: AppColor.aiResponseBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.avatarS),
                      decoration: BoxDecoration(
                        color: AppColor.aiResponseText.withOpacity(AppConstants.opacityMedium),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: AppColor.aiResponseText,
                        size: AppConstants.iconXs,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      'Respon AI',
                      style: SpatiumTypography.aiResponseTitle,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s...",
                  style: SpatiumTypography.aiResponseBody,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            children: [
              Icon(Icons.favorite_border, size: AppConstants.iconS, color: AppColor.placeholder),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                '24',
                style: SpatiumTypography.small,
              ),
              const SizedBox(width: AppConstants.spacingL),
              Icon(Icons.chat_bubble_outline, size: AppConstants.iconS, color: AppColor.placeholder),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                '8',
                style: SpatiumTypography.small,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
