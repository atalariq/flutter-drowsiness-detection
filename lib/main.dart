import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'screen/introduction.dart';
import 'screen/about_us.dart';
import 'screen/feedback.dart';
import 'screen/help.dart';
import 'screen/home.dart';
import 'screen/monitoring_v2.dart';
import 'screen/settings.dart';
import 'screen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Si Perisai',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/intro': (context) => const IntroductionPage(),
        '/home': (context) => const HomePage(),
        '/about': (context) => const AboutUsPage(),
        '/feedback': (context) => const FeedbackPage(),
        '/help': (context) => const HelpPage(),
        '/monitoring': (context) => MonitoringPageV2(cameras: cameras),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
