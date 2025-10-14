import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_desktop_app/gen/l10n/app_localizations.dart';
import 'theme.dart';
import 'provider/theme_provider.dart';
import 'provider/language_provider.dart';
import 'widgets/theme_toggler.dart';
import 'widgets/language_selector.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/admin_screen.dart';
import 'widgets/svg_icon.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const DPRAssessmentApp(),
    ),
  );
}

class DPRAssessmentApp extends StatelessWidget {
  const DPRAssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      locale: Locale(languageProvider.languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScaffold(), // ❌ removed const
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // ❌ removed const
    AnalyticsScreen(),
    ReportsScreen(),
    AdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          const LanguageSelector(),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) => ThemeToggler(
                isDarkMode: themeProvider.isDarkMode,
                onToggle: (isDark) => themeProvider.setTheme(isDark),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.accentCyan,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgIcon('assets/icons/home.svg',
                color: _currentIndex == 0 ? AppTheme.accentCyan : null),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('assets/icons/dashboard.svg',
                color: _currentIndex == 1 ? AppTheme.accentCyan : null),
            label: l10n.analytics,
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('assets/icons/reports.svg',
                color: _currentIndex == 2 ? AppTheme.accentCyan : null),
            label: l10n.reports,
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('assets/icons/admin.svg',
                color: _currentIndex == 3 ? AppTheme.accentCyan : null),
            label: l10n.admin,
          ),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => UploadScreen()), // ❌ removed const
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.upload_file, size: 28, color: Colors.white),
            SizedBox(height: 2),
            Text('Upload', style: TextStyle(fontSize: 10, color: Colors.white)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
