import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(camera: cameras.first));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrowsinessDetector(camera: camera),
    );
  }
}

class DrowsinessDetector extends StatefulWidget {
  final CameraDescription camera;

  const DrowsinessDetector({super.key, required this.camera});

  @override
  State<DrowsinessDetector> createState() => _DrowsinessDetectorState();
}

class _DrowsinessDetectorState extends State<DrowsinessDetector> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _isDrowsy = false;
  int _closedEyesFrameCount = 0;
  Timer? _alarmTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFaceDetector();
  }

  void _initializeCamera() {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _startImageStream();
    });
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.fast,
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
    final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ??
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
      _alarmTimer = Timer(Duration(seconds: 3), () {
        // 3-second interval
        _playAlarmSound();
      });
    }
  }

  void _cancelAlarm() {
    _alarmTimer?.cancel();
  }

  void _playAlarmSound() async {}

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    _alarmTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Drowsiness Detector')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller),
          ),
          Text(
            _isDrowsy ? 'DROWSY! Wake up!' : 'Awake',
            style: TextStyle(
                fontSize: 24, color: _isDrowsy ? Colors.red : Colors.green),
          ),
        ],
      ),
    );
  }
}
