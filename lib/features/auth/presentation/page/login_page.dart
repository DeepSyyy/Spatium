import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';
import 'package:spatium/features/auth/presentation/providers/auth_state.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/button_app.dart';
import 'package:spatium/usable/custom_text_field.dart';
import 'package:spatium/usable/pages/main_navigation_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _recoveryCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isError = false;

  @override
  void dispose() {
    _recoveryCodeController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _isError = false;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final recoveryCode = _recoveryCodeController.text.trim();
      ref.read(authNotifierProvider.notifier).login(recoveryCode);
    } else {
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.when(
        authenticated: (authResponse) {
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
    final isLoading = authState.maybeWhen(
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
          onPressed: isLoading ? null : () => Navigator.pop(context),
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.spacingXl),
                    
                    // Info Text
                    Text(
                      'Masukkan recovery code untuk login',
                      style: SpatiumTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingXxl),

                    // Recovery Code Input
                    Text(
                      'Recovery Code*',
                      style: SpatiumTypography.labelSemiBold,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    SpatiumTextField(
                      controller: _recoveryCodeController,
                      hintText: 'Masukkan recovery code Anda',
                      isError: _isError,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Recovery code tidak boleh kosong';
                        }
                        if (value.trim().length < 8) {
                          return 'Recovery code tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingL),

                    // Info about recovery code
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
                              'Recovery code diberikan saat Anda pertama kali mendaftar. Simpan dengan aman untuk login kembali.',
                              style: SpatiumTypography.small.copyWith(
                                color: AppColor.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXxl),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ButtonApp(
                        text: 'Masuk',
                        onPressed: isLoading ? null : _handleLogin,
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
