import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrowsinessDetector {
  CameraController? cameraController;
  FaceDetector? faceDetector;
  bool isDetecting = false;
  bool isDrowsy = false;
  bool isPreviewEnabled = true;
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  Timer? drowsinessTimer;
  int alarmInterval = 5; // Default 5 seconds
  String alarmSound = 'alarm1'; // Default alarm sound
  bool isAlarmPlaying = false;

  Future<void> initialize() async {
    await _loadSettings();
    await _initializeCamera();
    _initializeFaceDetector();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isPreviewEnabled = prefs.getBool('previewEnabled') ?? true;
    cameraLensDirection =
        CameraLensDirection.values[prefs.getInt('cameraMode') ?? 0];
    alarmInterval = prefs.getInt('alarmInterval') ?? 5;
    alarmSound = prefs.getString('alarmSound') ?? 'alarm1';
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras
          .firstWhere((camera) => camera.lensDirection == cameraLensDirection),
      ResolutionPreset.medium,
    );
    await cameraController?.initialize();
  }

  void _initializeFaceDetector() {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
      ),
    );
  }

  void _startDetection() {
    cameraController?.startImageStream((CameraImage image) async {
      if (isDetecting) return;

      isDetecting = true;
      final inputImage = _processCameraImage(image);
      final faces = await faceDetector?.processImage(inputImage);

      if (faces != null && faces.isNotEmpty) {
        final face = faces.first;
        final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
        final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

        if (leftEyeOpen < 0.4 && rightEyeOpen < 0.4) {
          if (!isDrowsy) {
            isDrowsy = true;
            _startDrowsinessTimer();
          }
        } else {
          _resetDrowsiness();
        }
      } else {
        _resetDrowsiness();
      }

      isDetecting = false;
    });
  }

  InputImage _processCameraImage(CameraImage image) {
    final camera = cameraController!.description;
    final plane = image.planes.first;
    final size = Size(image.width.toDouble(), image.height.toDouble());
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;
    final format = InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: size,
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void _startDrowsinessTimer() {
    drowsinessTimer?.cancel();
    drowsinessTimer = Timer(Duration(seconds: alarmInterval), () {
      if (isDrowsy) {
        _playAlarm();
      }
    });
  }

  void _resetDrowsiness() {
    isDrowsy = false;
    drowsinessTimer?.cancel();
    stopAlarm();
  }

  Future<void> startDetection() async {
    _startDetection();
  }

  Future<void> stopDetection() async {
    await cameraController?.stopImageStream();
    isDetecting = false;
  }

  Future<void> _playAlarm() async {
    if (!isAlarmPlaying) {
      isAlarmPlaying = true;
      FlutterRingtonePlayer().playAlarm();
    }
  }

  Future<void> stopAlarm() async {
    if (isAlarmPlaying) {
      FlutterRingtonePlayer().stop();
      isAlarmPlaying = false;
    }
  }

  void dispose() {
    cameraController?.dispose();
    faceDetector?.close();
    drowsinessTimer?.cancel();
  }

  Future<void> toggleMode() async {
    cameraLensDirection = cameraLensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    await _initializeCamera();
  }

  Future<void> togglePreview() async {
    isPreviewEnabled = !isPreviewEnabled;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('previewEnabled', isPreviewEnabled);
    });
  }

  Future<void> updateDrowsinessInterval(int newInterval) async {
    alarmInterval = newInterval;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('drowsinessInterval', newInterval);
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadSettings();
    await initialize();
  }
}
