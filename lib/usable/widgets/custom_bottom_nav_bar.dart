import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SafeArea(
        child: Container(
          height: AppConstants.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Home', 'assets/icons/navigation/Home.svg'),
              _buildNavItem(1, 'Timeline', 'assets/icons/navigation/Timeline.svg'),
              _buildNavItem(2, 'Chat AI', 'assets/icons/navigation/ChatAI.svg'),
              _buildNavItem(3, 'Profil', 'assets/icons/navigation/Profile.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: AppConstants.bottomNavItemWidth,
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: AppConstants.iconM,
              height: AppConstants.iconM,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColor.black : AppColor.greyLight,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              label,
              style: isSelected ? SpatiumTypography.navLabelSelected : SpatiumTypography.navLabel,
            ),
            const SizedBox(height: AppConstants.spacingXs),
            Container(
              height: AppConstants.bottomNavIndicatorHeight,
              width: AppConstants.bottomNavIndicatorWidth,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.black : AppColor.transparent,
                borderRadius: BorderRadius.circular(AppConstants.elevationLow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
