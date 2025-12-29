import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// Calendar Legend Widget
/// Shows the legend for calendar indicators
class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppColor.backgroundLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keterangan',
            style: SpatiumTypography.labelSemiBold,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Wrap(
            spacing: AppConstants.spacingL,
            runSpacing: AppConstants.spacingS,
            children: [
              _buildLegendItem('😊 Senang', AppColor.statusHappyBg),
              _buildLegendItem('😐 Netral', AppColor.statusNeutralBg),
              _buildLegendItem('😢 Sedih', AppColor.statusSadBg),
              _buildLegendItem('😠 Marah', AppColor.statusAngryBg),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Text(
                'Chat dengan AI',
                style: SpatiumTypography.small.copyWith(
                  color: AppColor.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: SpatiumTypography.small.copyWith(
            color: AppColor.secondary,
          ),
        ),
      ],
    );
  }
}
