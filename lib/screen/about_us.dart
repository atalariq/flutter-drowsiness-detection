import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Tentang Kami',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
              ),
            ),

            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),

            // App Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),

            SizedBox(
              height: 20,
            ),

            // App Logo and Version

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 80,
                    height: 800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Si Perisai",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Lexend",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Version 1.0",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Lexend",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.star),
                      label: Text("Nilai Aplikasi Kami"),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.download),
                      label: Text("Update Aplikasi"),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.lock),
                      label: Text("Kebijakan Privasi"),
                      onPressed: () {},
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.share),
                      label: Text("Bagikan Aplikasi Kami"),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.feedback),
                      label: Text("Berikan Masukan"),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.menu_book_outlined),
                      label: Text("Perkenalan Aplikasi"),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

String description = """
Aplikasi Microsleep merupakan aplikasi yang dikembankan untuk mengatasi kecelakaan di jalan raya. Aplikasi ini dirancang untuk memberikan peringatan saat pengendara mengalami kantuk dalam berkendara. Dengan adanya aplikasi ini diharapkan semua pengendara dapat lebih awas dan terhindar dari kecelakaan yang disebabkan oleh kantuk.
""";
