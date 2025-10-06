import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'provider/theme_provider.dart';
import 'widgets/theme_toggler.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/assessment_screen.dart';
// analysis moved into Home screen; no direct route from bottom nav
import 'screens/reports_screen.dart';
import 'screens/admin_screen.dart';
import 'widgets/svg_icon.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const DPRAssessmentApp(),
    ),
  );
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

  final List<Widget> _screens = [
    HomeScreen(),
    AssessmentScreen(),
    ReportsScreen(),
    AdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'DPR Assessment System',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('DPR Assessment System'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ThemeToggler(
                    isDarkMode: themeProvider.isDarkMode,
                    onToggle: (isDark) => themeProvider.setTheme(isDark),
                  ),
                ),
              ],
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_currentIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: AppTheme.accentCyan,
              unselectedItemColor: AppTheme.textSecondary,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: SvgIcon('assets/icons/home.svg', color: _currentIndex==0 ? AppTheme.accentCyan : null), label: 'Home'),
                BottomNavigationBarItem(icon: SvgIcon('assets/icons/dashboard.svg', color: _currentIndex==1 ? AppTheme.accentCyan : null), label: 'Assessment'),
                BottomNavigationBarItem(icon: SvgIcon('assets/icons/reports.svg', color: _currentIndex==2 ? AppTheme.accentCyan : null), label: 'Reports'),
                BottomNavigationBarItem(icon: SvgIcon('assets/icons/admin.svg', color: _currentIndex==3 ? AppTheme.accentCyan : null), label: 'Admin'),
              ],
              onTap: (index) => setState(() => _currentIndex = index),
            ),
            // Central Upload button (single prominent FAB)
            floatingActionButton: Builder(builder: (fabContext) {
              return FloatingActionButton.large(
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.of(fabContext).push(MaterialPageRoute(builder: (_) => const UploadScreen()));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.upload_file, size: 28, color: Colors.white),
                    SizedBox(height: 2),
                    Text('Upload', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
              );
            }),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}
