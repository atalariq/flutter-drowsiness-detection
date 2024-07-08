import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringPageV2 extends StatefulWidget {
  final CameraDescription camera;

  const MonitoringPageV2({super.key, required this.camera});

  @override
  State<MonitoringPageV2> createState() => _MonitoringPageV2State();
}

class _MonitoringPageV2State extends State<MonitoringPageV2> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _isDrowsy = false;
  int _closedEyesFrameCount = 0;
  Timer? _alarmTimer;
  bool _isAlarmPlaying = false;

  bool isPreviewEnabled = true;
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  int alarmInterval = 3;
  String alarmSound = 'alarm1';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeCamera();
    _initializeFaceDetector();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isPreviewEnabled = prefs.getBool('previewEnabled') ?? true;
    cameraLensDirection =
        CameraLensDirection.values[prefs.getInt('cameraMode') ?? 0];
    alarmInterval = prefs.getInt('alarmInterval') ?? 3;
    alarmSound = prefs.getString('alarmSound') ?? 'alarm1';
  }

  void _initializeCamera() {
    _controller = CameraController(
      widget.camera,
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.veryHigh
          : ResolutionPreset.high,
    );
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _startImageStream();
    });
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      // minFaceSize: 0.1,
      enableClassification: true,
      // enableLandmarks: true,
      // enableContours: true
      // enableTracking: true
    );
    _faceDetector = FaceDetector(options: options);
  }

  void _startImageStream() {
    _controller.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      _processCameraImage(image);
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation =
        InputImageRotationValue.fromRawValue(widget.camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    final faces = await _faceDetector.processImage(inputImage);
    _detectDrowsiness(faces);

    _isDetecting = false;
  }

  void _detectDrowsiness(List<Face> faces) {
    if (faces.isEmpty) {
      _closedEyesFrameCount = 0;
      return;
    }

    final face = faces[0];
    final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

    if (leftEyeOpen < 0.1 && rightEyeOpen < 0.1) {
      _closedEyesFrameCount++;
    } else {
      _closedEyesFrameCount = 0;
    }

    if (_closedEyesFrameCount > 30) {
      // Adjust this threshold as needed
      setState(() {
        _isDrowsy = true;
      });
      _scheduleAlarm();
    } else {
      setState(() {
        _isDrowsy = false;
      });
      _cancelAlarm();
    }
  }

  void _scheduleAlarm() {
    if (_alarmTimer == null || !_alarmTimer!.isActive) {
      _alarmTimer = Timer(Duration(seconds: alarmInterval), () {
        _playAlarmSound();
      });
    }
  }

  void _cancelAlarm() {
    _alarmTimer?.cancel();
  }

  void _playAlarmSound() async {
    if (!_isAlarmPlaying) {
      _isAlarmPlaying = true;

      FlutterRingtonePlayer().play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        looping: true,
        volume: 1.0,
      );
    }
  }

  Future<void> _stopAlarmSound() async {
    if (_isAlarmPlaying) {
      FlutterRingtonePlayer().stop();
    }

    setState(() {
      _isAlarmPlaying = false;
      _isDetecting = false;
    });
  }

  Future<void> _toggleDetection() async {
    if (_isDetecting) {
      await _controller.stopImageStream();
      _isDetecting = false;
    } else {
      _startImageStream();
    }
    setState(() {
      _isDetecting = !_isDetecting;
    });
  }

  Future<void> _toggleMode() async {
    cameraLensDirection = cameraLensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    _initializeCamera();
  }

  Future<void> _togglePreview() async {
    isPreviewEnabled = !isPreviewEnabled;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('previewEnabled', isPreviewEnabled);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    _alarmTimer?.cancel();
    _stopAlarmSound();
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
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Camera Preview
            Expanded(
              child: CameraPreview(_controller),
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
                          color: (isPreviewEnabled ? Colors.white : Colors.red),
                        ),
                        onPressed: () {
                          setState(() {
                            _togglePreview();
                          });
                        },
                      ),

                      SizedBox(width: 30),

                      // Start/Stop Detection
                      IconButton(
                        icon: Icon(
                          Icons.adjust_outlined,
                          size: 80,
                          color: _isAlarmPlaying ? Colors.red : Colors.white,
                        ),
                        onPressed: _isAlarmPlaying
                            ? _stopAlarmSound
                            : _toggleDetection,
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
                          await _toggleMode();
                          setState(() {});
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  // Label
                  Text(
                    "Status: ${_isDetecting ? (_isDrowsy ? 'Alarm Bunyi!' : 'Aktif') : 'Tidak Aktif'}",
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
