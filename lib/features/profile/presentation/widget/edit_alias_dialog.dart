import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/utils/pseudonym_generator.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// Dialog for editing user alias/pseudonym
class EditAliasDialog extends ConsumerStatefulWidget {
  final String currentAlias;
  final Future<void> Function(String newAlias) onSave;

  const EditAliasDialog({
    super.key,
    required this.currentAlias,
    required this.onSave,
  });

  @override
  ConsumerState<EditAliasDialog> createState() => _EditAliasDialogState();
}

class _EditAliasDialogState extends ConsumerState<EditAliasDialog> {
  final _aliasController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];
  bool _isLoading = false;
  int _selectedIndex = -1;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _aliasController.text = widget.currentAlias;
    _generateSuggestions();
  }

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  void _generateSuggestions() {
    setState(() {
      _suggestions = PseudonymGenerator.generateMultiple(4);
      _selectedIndex = -1;
    });
  }

  void _selectSuggestion(int index) {
    setState(() {
      _selectedIndex = index;
      _aliasController.text = _suggestions[index];
      _errorMessage = null;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final alias = _aliasController.text.trim();
    
    if (alias == widget.currentAlias) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onSave(alias);
      if (mounted) {
        Navigator.pop(context, alias);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: AppColor.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingS),
                  Expanded(
                    child: Text(
                      'Ubah Nama Samaran',
                      style: SpatiumTypography.h3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColor.placeholder),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.spacingL),

              // Suggestions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saran nama:',
                    style: SpatiumTypography.small.copyWith(
                      color: AppColor.placeholder,
                    ),
                  ),
                  InkWell(
                    onTap: _generateSuggestions,
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 14, color: AppColor.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Acak',
                          style: SpatiumTypography.small.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingS),
              
              Wrap(
                spacing: AppConstants.spacingXs,
                runSpacing: AppConstants.spacingXs,
                children: List.generate(_suggestions.length, (index) {
                  final isSelected = _selectedIndex == index;
                  return InkWell(
                    onTap: () => _selectSuggestion(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? AppColor.primary 
                          : AppColor.hintBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _suggestions[index],
                        style: SpatiumTypography.small.copyWith(
                          color: isSelected 
                            ? AppColor.white 
                            : AppColor.secondary,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppConstants.spacingM),

              // Input Field
              TextFormField(
                controller: _aliasController,
                decoration: InputDecoration(
                  labelText: 'Nama Samaran',
                  labelStyle: SpatiumTypography.small.copyWith(
                    color: AppColor.placeholder,
                  ),
                  hintText: 'Masukkan nama samaran baru...',
                  hintStyle: SpatiumTypography.bodyRegular.copyWith(
                    color: AppColor.placeholder,
                  ),
                  filled: true,
                  fillColor: AppColor.hintBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    borderSide: BorderSide(color: AppColor.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    borderSide: BorderSide(color: AppColor.error),
                  ),
                ),
                style: SpatiumTypography.bodyRegular,
                onChanged: (value) {
                  setState(() {
                    _selectedIndex = -1;
                    _errorMessage = null;
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

              // Error message
              if (_errorMessage != null) ...[
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  _errorMessage!,
                  style: SpatiumTypography.small.copyWith(
                    color: AppColor.error,
                  ),
                ),
              ],

              const SizedBox(height: AppConstants.spacingL),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingS),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, 
                      color: Colors.green[700], size: 16),
                    const SizedBox(width: AppConstants.spacingXs),
                    Expanded(
                      child: Text(
                        'Nama samaran menjaga privasi Anda di komunitas',
                        style: SpatiumTypography.small.copyWith(
                          color: Colors.green[700],
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingL),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColor.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingM,
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: SpatiumTypography.button.copyWith(
                          color: AppColor.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusS),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingM,
                        ),
                      ),
                      child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Simpan',
                            style: SpatiumTypography.button,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
