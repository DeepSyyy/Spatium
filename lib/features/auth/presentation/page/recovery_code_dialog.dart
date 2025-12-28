import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/button_app.dart';

class RecoveryCodeDialog extends StatelessWidget {
  final String alias;
  final String recoveryCode;
  final VoidCallback onContinue;

  const RecoveryCodeDialog({
    super.key,
    required this.alias,
    required this.recoveryCode,
    required this.onContinue,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: recoveryCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColor.white),
            const SizedBox(width: AppConstants.spacingS),
            Text(
              'Recovery code disalin!',
              style: SpatiumTypography.button.copyWith(color: AppColor.white),
            ),
          ],
        ),
        backgroundColor: AppColor.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
        ),
        margin: const EdgeInsets.all(AppConstants.spacingL),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColor.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),

            // Title
            Text(
              'Registrasi Berhasil!',
              style: SpatiumTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingS),

            // Welcome message
            Text(
              'Selamat datang, $alias!',
              style: SpatiumTypography.bodyRegular.copyWith(
                color: AppColor.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Important Info
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppColor.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                border: Border.all(
                  color: AppColor.warning.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColor.warning,
                    size: AppConstants.iconS,
                  ),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      'PENTING! Simpan recovery code ini dengan aman. Anda akan membutuhkannya untuk login kembali.',
                      style: SpatiumTypography.small.copyWith(
                        color: AppColor.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),

            // Recovery Code Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: AppColor.hintBackground,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(
                  color: AppColor.border,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Recovery Code Anda:',
                    style: SpatiumTypography.small.copyWith(
                      color: AppColor.secondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  SelectableText(
                    recoveryCode,
                    style: SpatiumTypography.h2.copyWith(
                      color: AppColor.primary,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Copy Button
            OutlinedButton.icon(
              onPressed: () => _copyToClipboard(context),
              icon: Icon(Icons.copy, size: AppConstants.iconXs),
              label: Text('Salin Recovery Code'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.primary,
                side: BorderSide(color: AppColor.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingL,
                  vertical: AppConstants.spacingM,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ButtonApp(
                text: 'Lanjutkan',
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
