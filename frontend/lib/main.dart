import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/health_records_provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main/main_layout.dart';
import 'screens/records/all_records_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HealthRecordsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'MediSync',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppWrapper(),
            routes: {'/all-records': (context) => const AllRecordsScreen()},
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Defer initialization until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    // Check auth status first
    if (mounted) {
      await context.read<AuthProvider>().checkAuthStatus();

      // If authenticated, load all health records before showing dashboard
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        if (authProvider.isAuthenticated && authProvider.currentUser != null) {
          final healthProvider = context.read<HealthRecordsProvider>();
          await healthProvider.loadAllRecords(authProvider.currentUser!.id);
        }
      }

      // Ensure minimum splash screen display time (1 second)
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SplashScreen();
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const MainLayout();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
