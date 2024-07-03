import 'package:flutter/material.dart';

import '../component/statistic.dart';
import '../component/navigation_page_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // States
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StatsWidget(),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  destination: '/monitoring',
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavButton(
                  text: "Feedback",
                  icon: Icons.message_outlined,
                  destination: '/feedback',
                ),
                SizedBox(width: 20),
                NavButton(
                  text: "About",
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
