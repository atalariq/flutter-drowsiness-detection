import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _showIntroPage;

    // Loads preferences asynchronously and sets the value of _showIntroPage based on the 'isFirstLaunch' key in SharedPreferences.
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _showIntroPage = prefs.getBool('isFirstLaunch') ?? true;
  }

  /// Sets the value of the 'isFirstLaunch' key in the shared preferences to false.
  void _dontShowIntroAgain() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstLaunch', false);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();

    // Timer
    Future.delayed(Duration(seconds: 3), () {
      if (_showIntroPage) {
        _dontShowIntroAgain();
        Navigator.pushReplacementNamed(context, '/intro');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 200,
              height: 200,
            ),
            // const SizedBox(height: 20),
            const Text(
              'Si Perisai',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
