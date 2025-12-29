import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class NewSessionDialog extends StatefulWidget {
  const NewSessionDialog({super.key});

  @override
  State<NewSessionDialog> createState() => _NewSessionDialogState();
}

class _NewSessionDialogState extends State<NewSessionDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      setState(() {
        _errorText = 'Judul tidak boleh kosong';
      });
      return;
    }
    if (title.length < 3) {
      setState(() {
        _errorText = 'Judul minimal 3 karakter';
      });
      return;
    }
    Navigator.of(context).pop(title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      title: Text(
        'Percakapan Baru',
        style: SpatiumTypography.pageTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berikan judul untuk percakapan ini',
            style: SpatiumTypography.chatSmall,
          ),
          const SizedBox(height: AppConstants.spacingM),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Contoh: Curhat Hari Ini',
              hintStyle: SpatiumTypography.hint,
              filled: true,
              fillColor: AppColor.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
                vertical: AppConstants.spacingM,
              ),
              errorText: _errorText,
            ),
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              if (_errorText != null) {
                setState(() {
                  _errorText = null;
                });
              }
            },
            onSubmitted: (value) {
              _validateAndSubmit();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Batal',
            style: SpatiumTypography.chatSmall.copyWith(
              color: AppColor.black.withOpacity(0.6),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.black,
            foregroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
          child: Text(
            'Buat',
            style: SpatiumTypography.chatSmall.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
