import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// A reusable elevated button with an icon and label.
///
/// Example:
/// ```dart
/// ButtonApp(
///   icon: Icon(Icons.add),
///   label: 'Curhat Baru',
///   onPressed: () {},
/// );
/// ```
class ButtonApp extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final String? text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double iconSize;
  final bool isLoading;

  const ButtonApp({
    super.key,
    this.icon,
    this.label,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = AppConstants.elevationNone,
    this.padding = const EdgeInsets.symmetric(horizontal: AppConstants.spacingL, vertical: AppConstants.spacingM),
    this.borderRadius = AppConstants.spacingXl,
    this.iconSize = AppConstants.iconS,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = text ?? label ?? '';
    
    // If loading, show loading indicator
    if (isLoading) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColor.primary,
          foregroundColor: foregroundColor ?? AppColor.white,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBackgroundColor: (backgroundColor ?? AppColor.primary).withOpacity(0.6),
        ),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              foregroundColor ?? AppColor.white,
            ),
          ),
        ),
      );
    }
    
    // If no icon, use regular button
    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColor.primary,
          foregroundColor: foregroundColor ?? AppColor.white,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          displayText,
          style: SpatiumTypography.button,
        ),
      );
    }
    
    // If the provided icon is an Icon widget, apply the requested size
    final Widget iconWidget = icon is Icon
        ? Icon((icon as Icon).icon, size: iconSize, color: (icon as Icon).color)
        : icon!;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: iconWidget,
      label: Text(
        displayText,
        style: SpatiumTypography.button,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColor.primary,
        foregroundColor: foregroundColor ?? AppColor.white,
        elevation: elevation,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
