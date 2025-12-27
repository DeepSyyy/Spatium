import 'package:flutter/material.dart';
import 'package:spatium/features/home/presentation/page/home_page.dart';
import 'package:spatium/features/timeline/presentation/page/timeline_page.dart';
import 'package:spatium/features/chat_ai/presentation/page/chat_ai_page.dart';
import 'package:spatium/features/profile/presentation/page/profile_page.dart';
import 'package:spatium/usable/widgets/custom_bottom_nav_bar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TimelinePage(),
    const ChatAIPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
