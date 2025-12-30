import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/utils/pseudonym_generator.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// Alias Setup Page
/// Shown after Google Sign-In to let users choose a pseudonym
class AliasSetupPage extends ConsumerStatefulWidget {
  final String googleId;
  final String email;
  final String? photoUrl;
  final String? suggestedName;

  const AliasSetupPage({
    super.key,
    required this.googleId,
    required this.email,
    this.photoUrl,
    this.suggestedName,
  });

  @override
  ConsumerState<AliasSetupPage> createState() => _AliasSetupPageState();
}

class _AliasSetupPageState extends ConsumerState<AliasSetupPage> {
  final _aliasController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];
  bool _isLoading = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _generateSuggestions();
  }

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  void _generateSuggestions() {
    setState(() {
      _suggestions = PseudonymGenerator.generateMultiple(6);
      _selectedIndex = -1;
      _aliasController.clear();
    });
  }

  void _selectSuggestion(int index) {
    setState(() {
      _selectedIndex = index;
      _aliasController.text = _suggestions[index];
    });
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    final alias = _aliasController.text.trim();

    // Warn if it looks like a real name
    if (PseudonymGenerator.looksLikeRealName(alias)) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColor.warning),
              const SizedBox(width: AppConstants.spacingS),
              Text(
                'Peringatan Privasi',
                style: SpatiumTypography.h3,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama yang Anda masukkan terlihat seperti nama asli.',
                style: SpatiumTypography.bodyRegular,
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                'Untuk menjaga anonimitas Anda, kami sarankan menggunakan nama samaran.',
                style: SpatiumTypography.small.copyWith(
                  color: AppColor.placeholder,
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingS),
                decoration: BoxDecoration(
                  color: AppColor.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  border: Border.all(
                    color: AppColor.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility_off, 
                      color: AppColor.warning, size: 20),
                    const SizedBox(width: AppConstants.spacingS),
                    Expanded(
                      child: Text(
                        'Nama samaran membantu melindungi identitas Anda',
                        style: SpatiumTypography.small,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Ganti Nama',
                style: SpatiumTypography.button.copyWith(
                  color: AppColor.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.warning,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
              ),
              child: Text(
                'Tetap Gunakan',
                style: SpatiumTypography.button,
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    setState(() => _isLoading = true);

    // Return the alias to the calling page
    if (mounted) {
      Navigator.pop(context, alias);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundScaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 40,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingL),
                      Text(
                        'Pilih Nama Samaran',
                        style: SpatiumTypography.h1,
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        'Nama ini akan ditampilkan di komunitas',
                        style: SpatiumTypography.bodyRegular.copyWith(
                          color: AppColor.placeholder,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingXl),

                // Privacy Notice
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
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              color: Colors.green[700],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          Expanded(
                            child: Text(
                              'Privasi Anda Terjaga',
                              style: SpatiumTypography.h3.copyWith(
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingM),
                      _buildPrivacyItem(
                        'Nama asli dari Google TIDAK akan ditampilkan',
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      _buildPrivacyItem(
                        'Email hanya untuk pemulihan akun',
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      _buildPrivacyItem(
                        'Pengguna lain hanya melihat nama samaran Anda',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Suggestions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih nama yang tersedia:',
                      style: SpatiumTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _generateSuggestions,
                      icon: Icon(Icons.refresh, size: 18, color: AppColor.primary),
                      label: Text(
                        'Acak Ulang',
                        style: SpatiumTypography.small.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children: List.generate(_suggestions.length, (index) {
                    final isSelected = _selectedIndex == index;
                    return InkWell(
                      onTap: () => _selectSuggestion(index),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                          vertical: AppConstants.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppColor.primary 
                            : AppColor.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                              ? AppColor.primary 
                              : AppColor.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          _suggestions[index],
                          style: SpatiumTypography.bodyRegular.copyWith(
                            fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                            color: isSelected 
                              ? AppColor.white 
                              : AppColor.secondary,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: AppConstants.spacingL),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColor.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingM,
                      ),
                      child: Text(
                        'atau',
                        style: SpatiumTypography.small,
                      ),
                    ),
                    Expanded(child: Divider(color: AppColor.border)),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingL),

                // Custom Input
                Text(
                  'Buat nama sendiri:',
                  style: SpatiumTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
                
                TextFormField(
                  controller: _aliasController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama samaran...',
                    hintStyle: SpatiumTypography.bodyRegular.copyWith(
                      color: AppColor.placeholder,
                    ),
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      borderSide: BorderSide(color: AppColor.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      borderSide: BorderSide(color: AppColor.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      borderSide: BorderSide(color: AppColor.primary, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.edit_outlined,
                      color: AppColor.placeholder,
                    ),
                    suffixIcon: _aliasController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: AppColor.placeholder),
                            onPressed: () {
                              setState(() {
                                _aliasController.clear();
                                _selectedIndex = -1;
                              });
                            },
                          )
                        : null,
                  ),
                  style: SpatiumTypography.bodyRegular,
                  onChanged: (value) {
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama samaran tidak boleh kosong';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama samaran minimal 3 karakter';
                    }
                    if (value.trim().length > 30) {
                      return 'Nama samaran maksimal 30 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingS),
                Text(
                  'Tips: Gunakan nama yang unik dan mudah diingat',
                  style: SpatiumTypography.small.copyWith(
                    color: AppColor.placeholder.withValues(alpha: 0.7),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXxl),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      ),
                      elevation: AppConstants.elevationNone,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColor.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Lanjutkan',
                            style: SpatiumTypography.button,
                          ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingM),

                // Additional info
                Center(
                  child: Text(
                    'Anda dapat mengubah nama samaran nanti di pengaturan',
                    style: SpatiumTypography.small.copyWith(
                      color: AppColor.placeholder.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.green[600], size: 16),
        const SizedBox(width: AppConstants.spacingS),
        Expanded(
          child: Text(
            text,
            style: SpatiumTypography.small.copyWith(
              color: AppColor.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
