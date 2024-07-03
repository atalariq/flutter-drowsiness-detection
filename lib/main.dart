import 'package:flutter/material.dart';

import 'screen/about_us.dart';
import 'screen/feedback.dart';
import 'screen/help.dart';
import 'screen/home.dart';
import 'screen/monitoring.dart';
import 'screen/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Si Perisai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Si Perisai'),
        '/about': (context) => const AboutPage(),
        '/feedback': (context) => const FeedbackPage(),
        '/help': (context) => const HelpPage(),
        '/monitoring': (context) => const MonitoringPage(),
        '/settings': (context) => const SettingsPage(),
      }
    );
  }
}
