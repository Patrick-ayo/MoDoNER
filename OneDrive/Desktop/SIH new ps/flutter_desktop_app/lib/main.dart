import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/admin_screen.dart';
import 'widgets/top_nav.dart';
import 'widgets/svg_icon.dart';

void main() {
  runApp(const DPRAssessmentApp());
}

class DPRAssessmentApp extends StatefulWidget {
  const DPRAssessmentApp({super.key});

  @override
  State<DPRAssessmentApp> createState() => _DPRAssessmentAppState();
}

// Alias for tests that expect `MyApp`
class MyApp extends DPRAssessmentApp {
  const MyApp({super.key});
}

class _DPRAssessmentAppState extends State<DPRAssessmentApp> {
  int _currentIndex = 0;
  bool _isDark = true;

  final List<Widget> _screens = [
    HomeScreen(),
    UploadScreen(),
    AssessmentScreen(),
    AnalysisScreen(),
    ReportsScreen(),
    AdminScreen(),
  ];

  void _toggleTheme(bool dark) => setState(() => _isDark = dark);

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? AppTheme.dark : AppTheme.light;
    return MaterialApp(
      title: 'DPR Assessment System',
      theme: theme,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: TopNav(isDark: _isDark, onThemeChanged: _toggleTheme),
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppTheme.accentCyan,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: SvgIcon('assets/icons/home.svg', color: _currentIndex==0 ? AppTheme.accentCyan : null), label: 'Home'),
            BottomNavigationBarItem(icon: SvgIcon('assets/icons/upload.svg', color: _currentIndex==1 ? AppTheme.accentCyan : null), label: 'Upload'),
            BottomNavigationBarItem(icon: SvgIcon('assets/icons/dashboard.svg', color: _currentIndex==2 ? AppTheme.accentCyan : null), label: 'Assessment'),
            BottomNavigationBarItem(icon: SvgIcon('assets/icons/analysis.svg', color: _currentIndex==3 ? AppTheme.accentCyan : null), label: 'Analysis'),
            BottomNavigationBarItem(icon: SvgIcon('assets/icons/reports.svg', color: _currentIndex==4 ? AppTheme.accentCyan : null), label: 'Reports'),
            BottomNavigationBarItem(icon: SvgIcon('assets/icons/admin.svg', color: _currentIndex==5 ? AppTheme.accentCyan : null), label: 'Admin'),
          ],
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
