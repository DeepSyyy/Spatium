import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/features/timeline/presentation/widget/mood_selector.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/typography.dart';
import 'package:spatium/usable/custom_text_field.dart';

class CreateCurhatPage extends StatefulWidget {
  const CreateCurhatPage({super.key});

  @override
  State<CreateCurhatPage> createState() => _CreateCurhatPageState();
}

class _CreateCurhatPageState extends State<CreateCurhatPage> {
  final TextEditingController _curhatController = TextEditingController();
  String? _selectedKategori;
  String _selectedMood = 'Senang';
  bool _isError = false;

  final List<String> _kategoriList = [
    'Lorem Ipsum',
    'Pekerjaan',
    'Keluarga',
    'Percintaan',
    'Kesehatan',
    'Keuangan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _curhatController.dispose();
    super.dispose();
  }

  void _submitCurhat() {
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
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tulis curhatan terlebih dahulu',
                  style: SpatiumTypography.bodyRegular.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColor.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Simulasi gagal dikirim (untuk demo)
    // Dalam implementasi nyata, ini akan memanggil API
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CurhatFailedPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Curhat',
          style: SpatiumTypography.h1,
        ),
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
                  const SizedBox(height: 24),

              // Kategori Dropdown
              Text(
                'Kategori',
                style: SpatiumTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
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
                      'Lorem Ipsum',
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
              const SizedBox(height: 24),

              // Isi Curhat Text Area
              Text(
                'Isi Curhat*',
                style: SpatiumTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SpatiumTextField.area(
                controller: _curhatController,
                hintText: 'Lorem Ipsum',
                isError: _isError,
              ),
              const SizedBox(height: 24),

              // Kirim Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submitCurhat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Kirim',
                    style: SpatiumTypography.button,
                  ),
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
      backgroundColor: AppColor.white,
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
              padding: const EdgeInsets.all(16.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                  const SizedBox(height: 40),
                  // Text
                  Text(
                    'Curhatan gagal dikirim',
                    style: SpatiumTypography.h1.copyWith(fontSize: 20),
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
