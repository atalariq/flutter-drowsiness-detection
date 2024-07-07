import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DrowsinessDetector {
  CameraController? cameraController;
  FaceDetector? faceDetector;
  bool isDetecting = false;
  bool isDrowsy = false;
  bool isPreviewEnabled = true;
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;

  Future<void> initialize() async {
    await _initializeCamera();
    _initializeFaceDetector();
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

  void dispose() {
    cameraController?.dispose();
    faceDetector?.close();
  }

  void startDetection() {
    cameraController?.startImageStream((CameraImage image) async {
      if (isDetecting) return;

      isDetecting = true;
      final inputImage = _processCameraImage(image);
      final faces = await faceDetector?.processImage(inputImage);

      if (faces != null && faces.isNotEmpty) {
        final face = faces.first;
        final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
        final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

        isDrowsy = (leftEyeOpen < 0.4 && rightEyeOpen < 0.4);
      }

      isDetecting = false;
    });
  }

  Future<void> toggleMode() async {
    cameraLensDirection = (cameraLensDirection == CameraLensDirection.front)
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    await cameraController?.stopImageStream();
    await initialize();
  }

  void togglePreview() {
    isPreviewEnabled = !isPreviewEnabled;
  }
}
