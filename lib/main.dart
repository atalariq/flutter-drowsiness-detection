import 'package:flutter/material.dart';
import 'screen/introduction.dart';
import 'screen/about_us.dart';
import 'screen/feedback.dart';
import 'screen/help.dart';
import 'screen/home.dart';
import 'screen/monitoring.dart';
import 'screen/settings.dart';
import 'screen/splash.dart';

import 'detector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DrowsinessDetector _drowsinessDetector;

  @override
  void initState() {
    super.initState();
    _drowsinessDetector = DrowsinessDetector();
    _drowsinessDetector.initialize();
  }

  @override
  void dispose() {
    _drowsinessDetector.stopDetection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Si Perisai',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/intro': (context) => const IntroductionPage(),
        '/home': (context) => const HomePage(),
        '/about': (context) => const AboutUsPage(),
        '/feedback': (context) => const FeedbackPage(),
        '/help': (context) => const HelpPage(),
        '/monitoring': (context) => const MonitoringPage(),
        '/settings': (context) => SettingsPage(
              drowsinessDetector: _drowsinessDetector,
            ),
      },
    );
  }
}
