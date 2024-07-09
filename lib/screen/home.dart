import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/statistic.dart';
import '../component/navigation_page_button.dart';
import 'monitoring.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage({super.key, required this.cameras});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _uptime = 0;
  int _oldUptime = 0;
  double _awakenessLevel = 0.0;
  double _drowsinessLevel = 0.0;

  void _resetStat() {
    setState(() {
      _uptime = 0;
      _oldUptime = 0;
      _drowsinessLevel = 0.0;
      _awakenessLevel = 0.0;
    });
    _saveStats();
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('statUptime', _uptime);
    await prefs.setDouble('statAwakenessLevel', _awakenessLevel);
    await prefs.setDouble('statDrowsinessLevel', _drowsinessLevel);
  }

  _navigateNextPageAndRetriveValue(BuildContext context) async {
    final List nextPageValues = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MonitoringPage(
                cameras: widget.cameras,
              )),
    );
    setState(() {
      _oldUptime = _uptime;
      _uptime = nextPageValues[0];
      _awakenessLevel = nextPageValues[1];
      _drowsinessLevel = nextPageValues[2];
    });
  } //code continues below

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Si Perisai",
          style: const TextStyle(
            fontSize: 28,
            fontFamily: "Lexend",
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Row(
          children: [
            SizedBox(width: 20),
            Image.asset(
              "assets/logo.png",
              height: 80,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              size: 36,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),

            // Statistic
            StatWidget(
              uptime: (_uptime + _oldUptime),
              awakenessLevel: _awakenessLevel,
              drowsinessLevel: _drowsinessLevel,
              resetStat: _resetStat,
            ),

            // Buttons
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NavButton(
                  text: "Pelajari",
                  icon: Icons.help_outline,
                  destination: '/help',
                ),
                SizedBox(width: 20),
                NavButton(
                  text: "Mulai",
                  icon: Icons.adjust_outlined,
                  onTap: () {
                    _navigateNextPageAndRetriveValue(context);
                  },
                  // destination: '/monitoring',
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                NavButton(
                  text: "Umpan\nBalik",
                  icon: Icons.message_outlined,
                  destination: '/feedback',
                ),
                SizedBox(width: 20),
                NavButton(
                  text: "Tentang\nKami",
                  icon: Icons.info_outline_rounded,
                  destination: '/about',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
