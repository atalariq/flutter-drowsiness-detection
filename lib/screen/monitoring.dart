import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MonitoringPage({super.key, required this.cameras});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  static const platform = MethodChannel('com.riqqq.siperisai/volume');

  late CameraController _controller;
  late FaceDetector _faceDetector;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  bool _detectionEnabled = false;
  bool _isDetecting = false;
  bool _isDrowsy = false;
  bool _isAlarmPlaying = false;
  int _closedEyesFrameCount = 0;

  bool isPreviewEnabled = true;
  int _cameraIndex = 1;
  int alarmInterval = 3;
  String alarmSound = 'alarm1';

  // Statistics =========================================================
  final Stopwatch _detectorUptime = Stopwatch();
  int _totalFrames = 0;
  double _sumEyeOpenProbabilities = 0.0;

  Timer? uptimeTimer;
  int _uptime = 0;
  double _awakenessLevel = 0.0;
  double _drowsinessLevel = 0.0;

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    _uptime = prefs.getInt('statUptime') ?? 0;
    _awakenessLevel = prefs.getDouble('statAwakenessLevel') ?? 0.0;
    _drowsinessLevel = prefs.getDouble('statDrowsinessLevel') ?? 0.0;
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('statUptime', _uptime);
    await prefs.setDouble('statAwakenessLevel', _awakenessLevel);
    await prefs.setDouble('statDrowsinessLevel', _drowsinessLevel);
  }

  // =====================================================================================================

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadStats();
    _initializeCamera();
    _initializeFaceDetector();
    // _playAlarmSound();
    platform.setMethodCallHandler(_handleMethodCall);
  }

  // For debugging
  bool enableLogging = false;

  void _customLog(String message) {
    if (!enableLogging) return;

    return log(
      message,
      name: "Custom Bro!",
      level: 1000,
      error: message,
    );
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'volumeButtonPressed':
        if (call.arguments == 'up') {
          _playAlarmSound();
        } else if (call.arguments == 'down') {
          _stopAlarmSound();
          // Handle volume down button press
        }
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isPreviewEnabled = prefs.getBool('previewEnabled') ?? true;
    _cameraIndex = prefs.getInt('cameraMode') ?? 1;
    alarmInterval = prefs.getInt('alarmInterval') ?? 3;
    alarmSound = prefs.getString('alarmSound') ?? 'alarm1';

    _customLog(
        'Settings loaded: previewEnabled=$isPreviewEnabled, cameraLensDirection=$_cameraIndex, drowsinessInterval=$alarmInterval, alarmSound=$alarmSound');
  }

  void _initializeCamera() {
    _controller = CameraController(
      widget.cameras[_cameraIndex],
      ResolutionPreset.low,
      enableAudio: false,
    );
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      // _startImageStream();
    });

    _customLog('Camera initialized with direction: $_cameraIndex');
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      minFaceSize: 0.3,
      enableClassification: true,
      // enableLandmarks: false,
      // enableContours: false,
      // enableTracking: false,
    );
    _faceDetector = FaceDetector(options: options);

    _customLog('Face detector initialized');
  }

  void _toggleDetection() {
    setState(() {
      _detectionEnabled = !_detectionEnabled;
    });
    if (_detectionEnabled) {
      _startImageStream();
    } else {
      _stopImageStream();
    }
  }

  void _startImageStream() {
    _customLog(
        "BBBBB: _startImageStream() executed. isDetecting: $_isDetecting");

    _controller.startImageStream((CameraImage image) {
      _customLog("BBBBB: _controller() executed. isDetecting: $_isDetecting");
      if (_isDetecting) return;
      _processCameraImage(image);
      _isDetecting = true;
      _detectorUptime.start();
      _startUptimeTimer();
    });
  }

  void _stopImageStream() {
    _customLog(
        "BBBBB: _stopImageStream() executed. isDetecting: $_isDetecting");

    if (_isDetecting) {
      _controller.stopImageStream();
      _detectorUptime.stop();
      uptimeTimer?.cancel();
    }
  }

  void _startUptimeTimer() {
    uptimeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _uptime = _detectorUptime.elapsed.inSeconds;
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final camera = _controller.description;
    final sensorOrientation = camera.sensorOrientation;

    _customLog(
        "BBBBB: _processImageCamera() executed. camera: $camera, sensor: $sensorOrientation");

    final plane = image.planes.first;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    InputImageRotation? imageRotation;
    if (Platform.isIOS) {
      imageRotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller.value.deviceOrientation];
      if (rotationCompensation == null) {
        _customLog('BBBBB: rotationCompensation null');
        return;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      imageRotation =
          InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (imageRotation == null) {
      _customLog('BBBBB: imageRotation error');
      return;
    }

    final imageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: imageFormat,
      bytesPerRow: plane.bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    // final inputImage = _inputImageFromCameraImage(image);

    try {
      _customLog('BBBBB: Try Detect Drowsiness');
      final faces = await _faceDetector.processImage(inputImage);
      _detectDrowsiness(faces);
    } catch (e) {
      _customLog('BBBBB: Error processing image: $e');
    } finally {
      _isDetecting = false;
    }
  }

  void _detectDrowsiness(List<Face> faces) {
    _customLog("BBBBB: Faces detected: ${faces.length}");
    if (faces.isEmpty) {
      setState(() {
        _closedEyesFrameCount = 0;
      });
      // _stopAlarmSound();
      return;
    }

    final face = faces[0];
    final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

    _totalFrames++;
    _sumEyeOpenProbabilities += (leftEyeOpen + rightEyeOpen) / 2;
    _awakenessLevel = _sumEyeOpenProbabilities / _totalFrames;
    _drowsinessLevel = 1.0 - _awakenessLevel;

    if (leftEyeOpen < 0.1 && rightEyeOpen < 0.1) {
      _closedEyesFrameCount++;
    } else {
      _closedEyesFrameCount = 0;
    }

    if (_closedEyesFrameCount > (alarmInterval * 10)) {
      _isDrowsy = true;
      _playAlarmSound();
      // _stopImageStream();
    } else {
      _isDrowsy = false;
      // _stopAlarmSound();
    }

    _customLog(
        'BBBBB: Left Eye: $leftEyeOpen, Right Eye: $rightEyeOpen, Count: $_closedEyesFrameCount, Drowsy: $_isDrowsy');
  }

  void _playAlarmSound() async {
    _customLog("BBBBB: _playAlarmSound() executed");

    if (!_isAlarmPlaying) {
      // FlutterRingtonePlayer().playAlarm(
      //   looping: true,
      //   // volume: 1.0,
      // );

      // FlutterRingtonePlayer().play(
      //   fromAsset: "assets/audio/sound-alert.mp3",
      //   looping: true,
      // );
      FlutterRingtonePlayer().play(
        fromAsset: "assets/audio/sound-alarm1.mp3",
        volume: 1.0,
        looping: true,
      );
      setState(() {
        _isAlarmPlaying = true;
      });
    }
  }

  Future<void> _stopAlarmSound() async {
    _customLog("BBBBB: _stopAlarmSound() executed");
    if (_isAlarmPlaying) {
      FlutterRingtonePlayer().stop();
      setState(() {
        _isAlarmPlaying = false;
      });
    }
  }

  void _toggleMode() {
    _cameraIndex = (_cameraIndex + 1) % widget.cameras.length;
    _controller.dispose();

    _controller = CameraController(
      widget.cameras[_cameraIndex],
      ResolutionPreset.low,
      enableAudio: false,
    );

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });

    if (_detectionEnabled) {
      _isDetecting = false;
      _startImageStream();
    }
  }

  void _togglePreview() {
    setState(() {
      isPreviewEnabled = !isPreviewEnabled;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    _saveStats();
    _stopAlarmSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
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
            _saveStats();
            Navigator.pop(context, [
              _uptime,
              _awakenessLevel,
              _drowsinessLevel,
            ]);
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),

            // Camera Preview
            Stack(
              children: [
                isPreviewEnabled
                    ? CameraPreview(_controller)
                    : Container(
                        color: Colors.black,
                        child: const Text(
                          "Pratinjau Kamera Tidak Aktif!",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),

            Spacer(),

            // Status Label + Buttons
            Container(
              color: Colors.black,
              height: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Toggle Camera Preview
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.preview_outlined,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _togglePreview();
                              setState(() {});
                            },
                          ),
                          if (!isPreviewEnabled)
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 60,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _togglePreview();
                                setState(() {});
                              },
                            ),
                        ],
                      ),

                      SizedBox(width: 30),

                      // Start/Stop Detection
                      IconButton(
                        icon: Icon(
                          (_isAlarmPlaying)
                              ? Icons.alarm_on
                              : Icons.adjust_outlined,
                          size: 80,
                          color: (_isAlarmPlaying || _detectionEnabled)
                              ? Colors.red
                              : Colors.white,
                        ),
                        onPressed: (_isAlarmPlaying
                            ? _stopAlarmSound
                            : _toggleDetection),
                      ),

                      SizedBox(width: 30),

                      // Toggle Camera Mode
                      IconButton(
                        icon: Icon(
                          Icons.flip_camera_android_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _toggleMode();
                          setState(() {});
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  // Label
                  Text(
                    _isAlarmPlaying
                        ? 'Bangun!'
                        : (_detectionEnabled ? "Aktif" : 'Tidak Aktif'),
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 8,
                      color: (_detectionEnabled | _isAlarmPlaying)
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),

                  if (enableLogging)
                    Text(
                      (_isDrowsy || _isAlarmPlaying) ? 'Wake up!' : 'Awake',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          color: (_isDrowsy || _isAlarmPlaying)
                              ? Colors.red
                              : Colors.green),
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
