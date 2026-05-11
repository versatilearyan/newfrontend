import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/get_started_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const BlurApp());
}

class BlurApp extends StatefulWidget {
  const BlurApp({super.key});

  // ✅ Global access to theme state from anywhere
  static _BlurAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BlurAppState>();

  @override
  State<BlurApp> createState() => _BlurAppState();
}

class _BlurAppState extends State<BlurApp> {
  // ✅ Default dark mode
  ThemeMode _themeMode = ThemeMode.dark;

  bool get isDark => _themeMode == ThemeMode.dark;

  // ✅ Toggle theme
  void toggleTheme(bool dark) {
    setState(() {
      _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });

    // Update system nav colors dynamically
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: dark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            dark ? AppTheme.darkBg : Colors.white,
        systemNavigationBarIconBrightness:
            dark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blur',
      debugShowCheckedModeBanner: false,

      // ✅ Themes
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,

      // ✅ Smooth theme transition
      builder: (context, child) {
        return AnimatedTheme(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          data: Theme.of(context),
          child: child!,
        );
      },

      // ✅ App routes
      initialRoute: '/get-started',
      routes: {
        '/': (_) => const GetStartedScreen(),
        '/get-started': (_) => const GetStartedScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/otp': (context) {
          final email =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return OtpScreen(email: email);
        },
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}