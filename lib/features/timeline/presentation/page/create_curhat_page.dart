import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/features/home/presentation/providers/home_providers.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_providers.dart';
import 'package:spatium/features/timeline/presentation/widget/mood_selector.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/custom_text_field.dart';

class CreateCurhatPage extends ConsumerStatefulWidget {
  const CreateCurhatPage({super.key});

  @override
  ConsumerState<CreateCurhatPage> createState() => _CreateCurhatPageState();
}

class _CreateCurhatPageState extends ConsumerState<CreateCurhatPage> {
  final TextEditingController _curhatController = TextEditingController();
  String? _selectedKategori;
  String _selectedMood = 'Senang';
  bool _isError = false;
  bool _isSubmitting = false;

  final List<String> _kategoriList = [
    'Umum',
    'Pekerjaan',
    'Keluarga',
    'Percintaan',
    'Kesehatan',
    'Keuangan',
    'Lainnya',
  ];

  int _getMoodTagId(String mood) {
    switch (mood) {
      case 'Senang':
        return 1;
      case 'Sedih':
        return 2;
      case 'Marah':
        return 3;
      case 'Netral':
        return 4;
      default:
        return 4;
    }
  }

  @override
  void dispose() {
    _curhatController.dispose();
    super.dispose();
  }

  Future<void> _submitCurhat() async {
    setState(() {
      _isError = false;
    });

    if (_curhatController.text.trim().isEmpty) {
      setState(() {
        _isError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: AppColor.white),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Text(
                  'Tulis curhatan terlebih dahulu',
                  style: SpatiumTypography.button,
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
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await ref
        .read(timelineNotifierProvider.notifier)
        .createPost(
          _curhatController.text.trim(),
          _getMoodTagId(_selectedMood),
        );

    if (mounted) {
      setState(() => _isSubmitting = false);

      if (success) {
        // Navigate to success page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CurhatSuccessPage()),
        );
      } else {
        // Navigate to failed page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CurhatFailedPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        elevation: AppConstants.elevationNone,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Curhat', style: SpatiumTypography.h1),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Arc-shaped background hint (seperti busur lingkaran besar)
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mood Selector
                  MoodSelector(
                    selectedMood: _selectedMood,
                    onMoodChanged: (mood) {
                      setState(() {
                        _selectedMood = mood;
                      });
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingXxl),

                  // Kategori Dropdown
                  Text('Kategori', style: SpatiumTypography.labelSemiBold),
                  const SizedBox(height: AppConstants.spacingS),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKategori,
                        hint: Text(
                          'Pilih kategori',
                          style: SpatiumTypography.input.copyWith(
                            color: AppColor.placeholder,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: SpatiumTypography.input,
                        items: _kategoriList.map((String kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori,
                            child: Text(kategori),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedKategori = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXxl),

                  // Isi Curhat Text Area
                  Text('Isi Curhat*', style: SpatiumTypography.labelSemiBold),
                  const SizedBox(height: AppConstants.spacingS),
                  SpatiumTextField.area(
                    controller: _curhatController,
                    hintText: 'Ceritakan apa yang kamu rasakan...',
                    isError: _isError,
                  ),
                  const SizedBox(height: AppConstants.spacingXxl),

                  // Kirim Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitCurhat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        elevation: AppConstants.elevationNone,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacing32,
                          vertical: AppConstants.spacingM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusM,
                          ),
                        ),
                        disabledBackgroundColor: AppColor.primary.withOpacity(
                          0.7,
                        ),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.white,
                              ),
                            )
                          : Text('Kirim', style: SpatiumTypography.button),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman untuk curhatan gagal dikirim
class CurhatFailedPage extends StatelessWidget {
  const CurhatFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      body: Stack(
        children: [
          // Setengah lingkaran besar dari kiri ke kanan, menembus ke atas
          Positioned(
            top: -screenHeight * 0.05,
            left: -MediaQuery.of(context).size.width * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                color: AppColor.hintBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(2000),
                  bottomRight: Radius.circular(2000),
                ),
              ),
            ),
          ),
          // AppBar di atas hint
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.secondary),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Kembali ke timeline
                },
              ),
            ),
          ),
          // Content - SVG dan Text di tengah layar
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SVG Emoji sedih
                  SvgPicture.asset(
                    'assets/svg/sad.svg',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: AppConstants.spacing40),
                  // Text
                  Text(
                    'Curhatan gagal dikirim',
                    style: SpatiumTypography.failedTitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman untuk curhatan berhasil dikirim
class CurhatSuccessPage extends ConsumerWidget {
  const CurhatSuccessPage({super.key});

  void _navigateBack(BuildContext context, WidgetRef ref) {
    // Refresh home data and timeline before navigating back
    ref.read(homeNotifierProvider.notifier).loadHomeData();
    ref.read(timelineNotifierProvider.notifier).loadPosts();
    
    // Pop back to timeline (pop 2 times: success page -> create page -> timeline)
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      body: Stack(
        children: [
          // Setengah lingkaran besar dari kiri ke kanan, menembus ke atas
          Positioned(
            top: -screenHeight * 0.05,
            left: -MediaQuery.of(context).size.width * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                color: AppColor.statusHappyBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(2000),
                  bottomRight: Radius.circular(2000),
                ),
              ),
            ),
          ),
          // AppBar di atas hint
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.secondary),
                onPressed: () => _navigateBack(context, ref),
              ),
            ),
          ),
          // Content - Icon dan Text di tengah layar
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColor.statusHappyBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColor.statusHappyText,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacing40),
                  // Text
                  Text(
                    'Curhatan berhasil dikirim!',
                    style: SpatiumTypography.failedTitle.copyWith(
                      color: AppColor.statusHappyText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  Text(
                    'AI akan segera memberikan respons untuk curhatanmu',
                    style: SpatiumTypography.bodyRegular.copyWith(
                      color: AppColor.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacing40),
                  ElevatedButton(
                    onPressed: () => _navigateBack(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacing32,
                        vertical: AppConstants.spacingM,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Timeline',
                      style: SpatiumTypography.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
