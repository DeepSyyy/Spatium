import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/services/google_sign_in_service.dart';
import 'package:spatium/features/auth/presentation/page/alias_setup_page.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';
import 'package:spatium/features/auth/presentation/providers/auth_providers.dart';
import 'package:spatium/features/auth/presentation/providers/auth_state.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/pages/main_navigation_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _googleSignInService = GoogleSignInService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      print('🔵 Starting Google Sign In process...');
      final account = await _googleSignInService.signIn();
      print('🔵 Received account: $account');
      
      if (account != null) {
        print('✅ Account received successfully');
        print('📧 Email: ${account.email}');
        print('👤 Display Name: ${account.displayName}');
        print('🆔 ID: ${account.id}');
        
        // Get user info
        final googleId = account.id;
        final email = account.email;
        final photoUrl = account.photoUrl;

        // Navigate to alias setup page first
        if (mounted) {
          final alias = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => AliasSetupPage(
                googleId: googleId,
                email: email,
                photoUrl: photoUrl,
                suggestedName: account.displayName,
              ),
            ),
          );

          // If user completed alias setup, proceed with login
          if (alias != null && alias.isNotEmpty) {
            print('🔵 Calling backend login with alias: $alias');
            await ref.read(authNotifierProvider.notifier).googleLogin(
              googleId: googleId,
              email: email,
              alias: alias,
              photoUrl: photoUrl,
            );
          } else {
            print('⚠️ Alias setup was cancelled');
            // Sign out from Google since user cancelled
            await _googleSignInService.signOut();
          }
        }
      } else {
        print('⚠️ Account is null - sign in was cancelled or failed');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: AppColor.white),
                  const SizedBox(width: AppConstants.spacingS),
                  const Expanded(
                    child: Text('Google Sign In dibatalkan atau gagal'),
                  ),
                ],
              ),
              backgroundColor: AppColor.error,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('❌ Error during Google Sign In: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: AppColor.white),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text('Login gagal: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: AppColor.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.when(
        authenticated: (authResponse) {
          // Invalidate login status provider to refresh cache
          ref.invalidate(isLoggedInProvider);
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColor.white),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      'Selamat datang kembali, ${authResponse.alias}!',
                      style: SpatiumTypography.button.copyWith(
                        color: AppColor.white,
                      ),
                    ),
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

          // Navigate to main app
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainNavigationPage(),
                ),
              );
            }
          });
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: AppColor.white),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      message,
                      style: SpatiumTypography.button.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColor.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              margin: const EdgeInsets.all(AppConstants.spacingL),
            ),
          );
        },
        initial: () {},
        loading: () {},
        unauthenticated: () {},
      );
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = _isLoading || authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: AppConstants.elevationNone,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.secondary),
          onPressed: isLoading ? null : () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Lanjutkan',
          style: SpatiumTypography.h1,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Arc-shaped background
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.60,
            left: -MediaQuery.of(context).size.width * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: AppColor.hintBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(2000),
                  bottomRight: Radius.circular(2000),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // Logo or App Name
                  Text(
                    'Spatium',
                    style: SpatiumTypography.h1.copyWith(
                      fontSize: 48,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  
                  Text(
                    'Masuk dengan akun Google Anda',
                    style: SpatiumTypography.bodyMedium.copyWith(
                      color: AppColor.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),

                  // Google Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _handleGoogleSignIn,
                      icon: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.white,
                              ),
                            )
                          : Image.asset(
                              'assets/icons/google_logo.png',
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.login, color: AppColor.white),
                            ),
                      label: Text(
                        isLoading ? 'Memproses...' : 'Masuk dengan Google',
                        style: SpatiumTypography.button.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXxl),
                  
                  // Privacy Info - Enhanced Disclaimer
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.primary.withValues(alpha: 0.08),
                          Colors.green.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shield_outlined,
                                color: Colors.green[700],
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingS),
                            Text(
                              'Privasi Anda Terlindungi',
                              style: SpatiumTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, 
                              color: Colors.green[600], size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Email Anda HANYA untuk pemulihan akun',
                                style: SpatiumTypography.small.copyWith(
                                  color: AppColor.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, 
                              color: Colors.green[600], size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Nama asli Anda TIDAK akan ditampilkan',
                                style: SpatiumTypography.small.copyWith(
                                  color: AppColor.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, 
                              color: Colors.green[600], size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Anda akan membuat nama samaran setelah ini',
                                style: SpatiumTypography.small.copyWith(
                                  color: AppColor.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
