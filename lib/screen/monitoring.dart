import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../detector.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final DrowsinessDetector _drowsinessDetector = DrowsinessDetector();
  bool _isDrowsy = false;

  Future<void> _initializeDrowsinessDetector() async {
    await _drowsinessDetector.initialize();
    _drowsinessDetector.cameraController?.addListener(() {
      if (_drowsinessDetector.isDrowsy != _isDrowsy) {
        setState(() {
          _isDrowsy = _drowsinessDetector.isDrowsy;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDrowsinessDetector();
  }

  @override
  void dispose() {
    _drowsinessDetector.dispose();
    super.dispose();
  }

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Camera Preview

            Stack(
              children: [
                if (_drowsinessDetector.cameraController != null &&
                    _drowsinessDetector.cameraController!.value.isInitialized &&
                    _drowsinessDetector.isPreviewEnabled)
                  CameraPreview(_drowsinessDetector.cameraController!),
                // if (_isDrowsy)
                //   Center(
                //     child: Container(
                //       padding: EdgeInsets.all(16.0),
                //       color: Colors.red,
                //       child: Text(
                //         'You are drowsy!',
                //         style: TextStyle(fontSize: 24, color: Colors.white),
                //       ),
                //     ),
                //   ),
              ],
            ),

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
                        icon: Icon(
                          Icons.preview_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                        onPressed: _drowsinessDetector.togglePreview,
                      ),

                      SizedBox(width: 30),

                      // Start/Stop Detection
                      IconButton(
                        icon: Icon(
                          Icons.adjust_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                        onPressed: _drowsinessDetector.startDetection,
                      ),

                      SizedBox(width: 30),

                      // Toggle Camera Mode
                      IconButton(
                        icon: Icon(
                          Icons.flip_camera_android_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                        onPressed: _drowsinessDetector.toggleMode,
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
