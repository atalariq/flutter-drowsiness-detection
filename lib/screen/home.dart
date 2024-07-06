import 'package:flutter/material.dart';

import '../component/statistic.dart';
import '../component/navigation_page_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: AppBar(
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
              size: 40,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),

            // Statistic
            StatsWidget(),

            // Buttons
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
