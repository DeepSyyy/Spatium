import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/auth/presentation/page/recovery_code_dialog.dart';
import 'package:spatium/features/auth/presentation/providers/auth_notifier.dart';import 'package:spatium/features/auth/presentation/providers/auth_providers.dart';import 'package:spatium/features/auth/presentation/providers/auth_state.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/button_app.dart';
import 'package:spatium/usable/custom_text_field.dart';
import 'package:spatium/usable/pages/main_navigation_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _aliasController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isError = false;

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    setState(() {
      _isError = false;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final alias = _aliasController.text.trim();
      ref.read(authNotifierProvider.notifier).register(alias);
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
          // Invalidate login status provider to refresh cache
          ref.invalidate(isLoggedInProvider);
          
          // Show recovery code dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RecoveryCodeDialog(
              alias: authResponse.alias,
              recoveryCode: authResponse.recoveryCode,
              onContinue: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to main app
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainNavigationPage(),
                  ),
                );
              },
            ),
          );
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
          onPressed: isLoading ? null : () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Daftar Akun',
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
                      'Buat akun untuk mulai menggunakan Spatium',
                      style: SpatiumTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingXxl),

                    // Alias Input
                    Text(
                      'Nama Alias*',
                      style: SpatiumTypography.labelSemiBold,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    SpatiumTextField(
                      controller: _aliasController,
                      hintText: 'Masukkan nama alias Anda',
                      isError: _isError,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alias tidak boleh kosong';
                        }
                        if (value.trim().length < 3) {
                          return 'Alias minimal 3 karakter';
                        }
                        if (value.trim().length > 50) {
                          return 'Alias maksimal 50 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingL),

                    // Info about alias
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
                              'Alias adalah nama yang akan ditampilkan di aplikasi. Anda akan mendapatkan recovery code untuk login kembali.',
                              style: SpatiumTypography.small.copyWith(
                                color: AppColor.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXxl),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ButtonApp(
                        text: 'Daftar',
                        onPressed: isLoading ? null : _handleRegister,
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
