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
  bool _isDetecting = false;
  bool _isAlarmPlaying = false;

  Future<void> _initializeDrowsinessDetector() async {
    await _drowsinessDetector.initialize();
    _drowsinessDetector.cameraController?.addListener(() {
      if (_drowsinessDetector.isDrowsy != _isDrowsy) {
        setState(() {
          _isDrowsy = _drowsinessDetector.isDrowsy;
          if (_isDrowsy) {
            _isAlarmPlaying = true;
          }
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

  Future<void> _toggleDetection() async {
    if (_isDetecting) {
      await _drowsinessDetector.stopDetection();
    } else {
      await _drowsinessDetector.startDetection();
    }
    setState(() {
      _isDetecting = !_isDetecting;
    });
  }

  Future<void> _stopAlarm() async {
    await _drowsinessDetector.stopAlarm();
    setState(() {
      _isAlarmPlaying = false;
      _isDetecting = false;
    });
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
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Camera Preview
            Stack(
              children: [
                if (_drowsinessDetector.cameraController != null &&
                    _drowsinessDetector.cameraController!.value.isInitialized &&
                    _drowsinessDetector.isPreviewEnabled)
                  CameraPreview(_drowsinessDetector.cameraController!)
              ],
            ),

            Spacer(),

            // Status Label + Buttons
            Container(
              color: Colors.black,
              height: 140,
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Toggle Camera Preview
                      IconButton(
                        icon: Icon(
                          Icons.preview_outlined,
                          size: 60,
                          color: (_drowsinessDetector.isPreviewEnabled
                              ? Colors.white
                              : Colors.red),
                        ),
                        onPressed: () {
                          setState(() {
                            _drowsinessDetector.togglePreview();
                          });
                        },
                      ),

                      SizedBox(width: 30),

                      // Start/Stop Detection
                      (_isAlarmPlaying || _isDetecting)
                          ? IconButton(
                              icon: Icon(
                                Icons.adjust_outlined,
                                size: 80,
                                color: Colors.red,
                              ),
                              onPressed: _stopAlarm,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.adjust_outlined,
                                size: 80,
                                color: Colors.white,
                              ),
                              onPressed: _toggleDetection,
                            ),

                      SizedBox(width: 30),

                      // Toggle Camera Mode
                      IconButton(
                        icon: Icon(
                          Icons.flip_camera_android_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _drowsinessDetector.toggleMode();
                          setState(() {});
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  // Label
                  Text(
                    "Status: ${_isDetecting ? (_isAlarmPlaying ? 'Alarm!!!' : 'Aktif') : 'Tidak Aktif'}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 8,
                    ),
                  ),
                  SizedBox(height: 5),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
