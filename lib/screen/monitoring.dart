import 'package:flutter/material.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // Camera Preview

            Spacer(),

            // Button
            Container(
              color: Colors.black,
              height: 120,
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // Label
                  Text(
                    'Status: Aktif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Toggle Camera Preview
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.preview_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 30),

                      // Start/Stop Detection
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.adjust_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 30),

                      // Toggle Camera Mode
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.flip_camera_android_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
