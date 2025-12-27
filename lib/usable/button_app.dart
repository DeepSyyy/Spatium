import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
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
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double iconSize;

  const ButtonApp({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderRadius = 20,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    // If the provided icon is an Icon widget, apply the requested size and
    // preserve its color if set; otherwise wrap/return the widget as-is.
    final Widget iconWidget = icon is Icon
        ? Icon((icon as Icon).icon, size: iconSize, color: (icon as Icon).color)
        : icon;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: iconWidget,
      label: Text(
        label,
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
