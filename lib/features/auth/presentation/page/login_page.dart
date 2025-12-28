import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/services/google_sign_in_service.dart';
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
        final displayName = account.displayName ?? email.split('@')[0];
        final photoUrl = account.photoUrl;

        print('🔵 Calling backend login...');
        // Login with backend
        await ref.read(authNotifierProvider.notifier).googleLogin(
          googleId: googleId,
          email: email,
          alias: displayName,
          photoUrl: photoUrl,
        );
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
          'Masuk',
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
                  
                  // Info
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    decoration: BoxDecoration(
                      color: AppColor.hintBackground,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColor.secondary,
                          size: AppConstants.iconS,
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Expanded(
                          child: Text(
                            'Kami menggunakan Google Sign In untuk keamanan dan kemudahan akses. Data Anda akan tersimpan dengan aman.',
                            style: SpatiumTypography.small.copyWith(
                              color: AppColor.secondary,
                            ),
                          ),
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
