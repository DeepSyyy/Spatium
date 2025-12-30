import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/core/services/google_sign_in_service.dart';
import 'package:spatium/features/auth/presentation/page/welcome_page.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';
import 'package:spatium/features/auth/presentation/providers/auth_providers.dart';
import 'package:spatium/features/profile/presentation/widget/edit_alias_dialog.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? _currentAlias;

  Future<void> _showEditAliasDialog(String currentAlias) async {
    final remoteDataSource = ref.read(authRemoteDataSourceProvider);
    final localDataSource = ref.read(authLocalDataSourceProvider);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => EditAliasDialog(
        currentAlias: currentAlias,
        onSave: (newAlias) async {
          // Call API to update alias
          await remoteDataSource.updateAlias(newAlias);
          // Update local storage
          await localDataSource.saveUserAlias(newAlias);
        },
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      setState(() {
        _currentAlias = result;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppColor.white),
              const SizedBox(width: AppConstants.spacingS),
              Text('Nama samaran berhasil diubah'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
        ),
      );
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
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
  Widget build(BuildContext context) {
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
                      final alias = _currentAlias ?? snapshot.data ?? 'User';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            alias,
                            style: SpatiumTypography.h1,
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          InkWell(
                            onTap: () => _showEditAliasDialog(alias),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColor.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ],
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
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingS),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.shield_outlined, 
                          color: Colors.green[700], size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Email hanya untuk pemulihan akun - tidak ditampilkan ke pengguna lain',
                            style: SpatiumTypography.small.copyWith(
                              color: Colors.green[700],
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
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
                onPressed: () => _handleLogout(context),
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
