import 'package:flutter/material.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// Mood Picker Dialog
/// Allows users to select their mood and add a note
class MoodPickerDialog extends StatefulWidget {
  final int? currentMoodId;
  final String? currentNote;

  const MoodPickerDialog({
    super.key,
    this.currentMoodId,
    this.currentNote,
  });

  @override
  State<MoodPickerDialog> createState() => _MoodPickerDialogState();
}

class _MoodPickerDialogState extends State<MoodPickerDialog> {
  int? _selectedMoodId;
  late TextEditingController _noteController;

  final List<_MoodOption> _moods = [
    _MoodOption(id: 1, emoji: '😊', label: 'Senang', color: AppColor.statusHappyBg),
    _MoodOption(id: 4, emoji: '😐', label: 'Netral', color: AppColor.statusNeutralBg),
    _MoodOption(id: 2, emoji: '😢', label: 'Sedih', color: AppColor.statusSadBg),
    _MoodOption(id: 3, emoji: '😠', label: 'Marah', color: AppColor.statusAngryBg),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMoodId = widget.currentMoodId;
    _noteController = TextEditingController(text: widget.currentNote ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bagaimana perasaanmu hari ini?',
              style: SpatiumTypography.h2,
            ),
            const SizedBox(height: AppConstants.spacingXl),
            
            // Mood emoji grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) => _buildMoodOption(mood)).toList(),
            ),
            
            const SizedBox(height: AppConstants.spacingXl),
            
            // Note input
            Text(
              'Catatan (opsional)',
              style: SpatiumTypography.labelSemiBold,
            ),
            const SizedBox(height: AppConstants.spacingS),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ceritakan tentang harimu...',
                hintStyle: SpatiumTypography.hint,
                filled: true,
                fillColor: AppColor.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(AppConstants.spacingM),
              ),
            ),
            
            const SizedBox(height: AppConstants.spacingXl),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: SpatiumTypography.button.copyWith(
                      color: AppColor.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                ElevatedButton(
                  onPressed: _selectedMoodId != null
                      ? () {
                          Navigator.pop(context, {
                            'moodId': _selectedMoodId,
                            'note': _noteController.text.trim(),
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    disabledBackgroundColor: AppColor.placeholder,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingXl,
                      vertical: AppConstants.spacingM,
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: SpatiumTypography.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(_MoodOption mood) {
    final isSelected = _selectedMoodId == mood.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMoodId = mood.id;
        });
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? mood.color : AppColor.backgroundLight,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColor.primary, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: mood.color.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                mood.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            mood.label,
            style: SpatiumTypography.small.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColor.primary : AppColor.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodOption {
  final int id;
  final String emoji;
  final String label;
  final Color color;

  _MoodOption({
    required this.id,
    required this.emoji,
    required this.label,
    required this.color,
  });
}
