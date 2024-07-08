import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Widget _customButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      children: [
        TextButton.icon(
          icon: Icon(
            icon,
            size: 22,
            color: Colors.black,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Roboto",
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
          onPressed: onPressed,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

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
                    height: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Si Perisai",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Lexend",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          fontSize: 10,
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
              height: 40,
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
                    _customButton(
                      icon: Icons.star,
                      label: "Nilai Aplikasi Kami",
                      onPressed: () {},
                    ),
                    _customButton(
                      icon: Icons.download,
                      label: "Update Aplikasi",
                      onPressed: () {},
                    ),
                    _customButton(
                      icon: Icons.lock,
                      label: "Kebijakan Privasi",
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customButton(
                      icon: Icons.share,
                      label: "Bagikan Aplikasi Kami",
                      onPressed: () {},
                    ),
                    _customButton(
                      icon: Icons.feedback,
                      label: "Berikan Masukan",
                      onPressed: () {},
                    ),
                    _customButton(
                      icon: Icons.menu_book_outlined,
                      label: "Perkenalan Aplikasi",
                      onPressed: () {
                        Navigator.pushNamed(context, '/intro');
                      },
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
