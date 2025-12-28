import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/features/auth/presentation/page/welcome_page.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Logout', style: SpatiumTypography.h2),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: SpatiumTypography.bodyRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: SpatiumTypography.button),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
            ),
            child: Text('Logout', style: SpatiumTypography.button),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Perform logout
      await ref.read(authNotifierProvider.notifier).logout();

      if (context.mounted) {
        // Navigate to welcome page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ),
          (route) => false, // Remove all previous routes
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user info from storage
    final userAliasFuture = ref.read(secureStorageServiceProvider).getUserAlias();
    final recoveryCodeFuture = ref.read(secureStorageServiceProvider).getRecoveryCode();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Profil', style: SpatiumTypography.appBarTitle),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        elevation: AppConstants.elevationNone,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColor.primary,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColor.white,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  FutureBuilder<String?>(
                    future: userAliasFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Text(
                          snapshot.data!,
                          style: SpatiumTypography.h1,
                        );
                      }
                      return Text(
                        'User',
                        style: SpatiumTypography.h1,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingXxl),

            // User Info Section
            Text(
              'Informasi Akun',
              style: SpatiumTypography.h2,
            ),
            const SizedBox(height: AppConstants.spacingL),

            // Recovery Code
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: AppColor.hintBackground,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: AppColor.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.key,
                        color: AppColor.primary,
                        size: AppConstants.iconS,
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Recovery Code',
                        style: SpatiumTypography.labelSemiBold,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  FutureBuilder<String?>(
                    future: recoveryCodeFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return SelectableText(
                          snapshot.data!,
                          style: SpatiumTypography.h3.copyWith(
                            color: AppColor.primary,
                            letterSpacing: 1.5,
                          ),
                        );
                      }
                      return Text(
                        '••••••••••••',
                        style: SpatiumTypography.h3.copyWith(
                          color: AppColor.secondary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    'Simpan recovery code ini dengan aman untuk login kembali',
                    style: SpatiumTypography.small.copyWith(
                      color: AppColor.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingXxl),

            // Logout Section
            Text(
              'Aksi',
              style: SpatiumTypography.h2,
            ),
            const SizedBox(height: AppConstants.spacingL),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleLogout(context, ref),
                icon: Icon(Icons.logout, size: AppConstants.iconS),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.error,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingL,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
