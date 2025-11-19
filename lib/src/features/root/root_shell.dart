import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/radar_background.dart';
import '../chatbot/chatbot_screen.dart';
import '../learn/play_learn_screen.dart';
import '../report/report_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  final _pages = const [ChatbotScreen(), ReportScreen(), PlayLearnScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadarBackground(
        padding: EdgeInsets.zero,
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outline)),
          color: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.accentGreen,
          unselectedItemColor: AppColors.textSecondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_outlined),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.extension_outlined),
              label: 'Play & Learn',
            ),
          ],
        ),
      ),
    );
  }
}
