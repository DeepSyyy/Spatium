import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/core/services/google_sign_in_service.dart';
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
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: Text('Konfirmasi Logout', style: SpatiumTypography.h2),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: SpatiumTypography.bodyRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: SpatiumTypography.button.copyWith(
                color: AppColor.secondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
            ),
            child: Text(
              'Logout',
              style: SpatiumTypography.button.copyWith(
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Also sign out from Google
      final googleService = GoogleSignInService();
      await googleService.signOut();
      
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
    final storageService = ref.read(secureStorageServiceProvider);
    final userAliasFuture = storageService.getUserAlias();
    final userEmailFuture = storageService.getUserEmail();
    final userPhotoUrlFuture = storageService.getUserPhotoUrl();

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
                  FutureBuilder<String?>(
                    future: userPhotoUrlFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColor.primary,
                          backgroundImage: NetworkImage(snapshot.data!),
                          onBackgroundImageError: (_, __) {},
                        );
                      }
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColor.primary,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColor.white,
                        ),
                      );
                    },
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
                  const SizedBox(height: AppConstants.spacingXs),
                  FutureBuilder<String?>(
                    future: userEmailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Text(
                          snapshot.data!,
                          style: SpatiumTypography.bodyMedium.copyWith(
                            color: AppColor.secondary,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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

            // Account Info Card
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
                      Image.asset(
                        'assets/icons/google_logo.png',
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.account_circle, color: AppColor.primary),
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Terhubung dengan Google',
                        style: SpatiumTypography.labelSemiBold,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  FutureBuilder<String?>(
                    future: userEmailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppColor.secondary,
                              size: 18,
                            ),
                            const SizedBox(width: AppConstants.spacingS),
                            Text(
                              snapshot.data!,
                              style: SpatiumTypography.bodyMedium.copyWith(
                                color: AppColor.secondary,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    'Akun Anda terhubung dengan Google untuk keamanan dan kemudahan akses',
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
                label: const Text('Logout'),
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
