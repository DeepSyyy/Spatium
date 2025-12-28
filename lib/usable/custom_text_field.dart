import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class SpatiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? label;
  final int maxLines;
  final int? minLines;
  final bool isError;
  final String? errorMessage;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const SpatiumTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.label,
    this.maxLines = 1,
    this.minLines,
    this.isError = false,
    this.errorMessage,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  // Constructor khusus untuk Area Panjang (Curhat Baru)
  factory SpatiumTextField.area({
    required TextEditingController controller,
    required String hintText,
    String? label,
    bool isError = false,
  }) {
    return SpatiumTextField(
      controller: controller,
      hintText: hintText,
      label: label,
      maxLines: 10,
      minLines: 5, // Tinggi minimum seperti di desain [UC-3]
      keyboardType: TextInputType.multiline,
      isError: isError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas input (jika ada)
        if (label != null) ...[
          Text(
            label!,
            style: SpatiumTypography.bodyRegular.copyWith(
              color: AppColor.secondary.withOpacity(AppConstants.opacity70),
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
        ],
        
        // Input Field
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(
              // Jika error border merah, jika tidak border abu/transparan
              color: isError ? AppColor.error : AppColor.border, 
              width: AppConstants.borderWidthThin,
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: keyboardType,
            style: SpatiumTypography.input,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: SpatiumTypography.input.copyWith(
                color: AppColor.placeholder,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppConstants.spacingL),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        
        // Pesan Error (jika ada)
        if (isError && errorMessage != null) ...[
          const SizedBox(height: AppConstants.avatarS),
          Text(
            errorMessage!,
            style: SpatiumTypography.small.copyWith(
              color: AppColor.error,
            ),
          ),
        ]
      ],
    );
  }
}