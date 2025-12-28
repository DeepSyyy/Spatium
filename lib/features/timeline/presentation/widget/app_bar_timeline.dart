import 'package:flutter/material.dart';
import 'package:spatium/features/timeline/presentation/page/create_curhat_page.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class TimelineAppbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  State<TimelineAppbar> createState() => _TimelineAppbarState();
}

class _TimelineAppbarState extends State<TimelineAppbar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: AppConstants.spacingS,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Timeline Curhat',
                style: screenWidth < AppConstants.smallScreenWidth 
                    ? SpatiumTypography.timelineTitleSmall 
                    : SpatiumTypography.h1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppConstants.spacingS),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCurhatPage(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM, vertical: AppConstants.avatarS),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: AppConstants.iconXs, color: AppColor.white),
                    const SizedBox(width: AppConstants.spacingXs),
                    Text(
                      "Curhat Baru",
                      style: SpatiumTypography.buttonSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
