import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);

    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  // Dispose of the camera controller
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // Take a picture
  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    final image = await _controller.takePicture();
    print('Picture taken: ${image.path}');
    // You can use the image path for further use (e.g., save it or display)
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          // Display the camera preview
          Expanded(
            child: CameraPreview(_controller),
          ),
          // Take picture button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
          ),
        ],
      ),
    );
  }
}
