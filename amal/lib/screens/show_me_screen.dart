import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../services/card_service.dart';
import 'dart:math';

class ShowMeScreen extends StatefulWidget {
  final String language;
  const ShowMeScreen({super.key, required this.language});

  @override
  State<ShowMeScreen> createState() => _ShowMeScreenState();
}

class _ShowMeScreenState extends State<ShowMeScreen> {
  CameraController? _cameraController;
  final AudioPlayer _player = AudioPlayer();
  VocabCard? _targetCard;
  List<VocabCard> _allCards = [];
  bool _showHint = false;
  bool _found = false;
  final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.5),
  );
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadCards();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final rear = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(rear, ResolutionPreset.medium);
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
      _startImageStream();
    }
  }

  Future<void> _loadCards() async {
    _allCards = await CardService.loadCards();
    _allCards = _allCards.where((c) =>
      c.mlLabels.isNotEmpty &&
      !c.mlLabels.first.startsWith('(')
    ).toList();
    _pickNewTarget();
  }

  void _pickNewTarget() {
    if (_allCards.isEmpty) return;
    _allCards.shuffle(Random());
    setState(() {
      _targetCard = _allCards.first;
      _found = false;
      _showHint = false;
    });
  }

  Future<void> _startImageStream() async {
    _cameraController!.startImageStream((CameraImage image) async {
      if (_isProcessing || _found) return;
      _isProcessing = true;
      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) {
          _isProcessing = false;
          return;
        }
        final labels = await _labeler.processImage(inputImage);
        final detectedLabels = labels.map((l) => l.label.toLowerCase()).toList();

        for (final detected in detectedLabels) {
          for (final target in _targetCard!.mlLabels) {
            if (detected.contains(target.toLowerCase()) ||
                target.toLowerCase().contains(detected)) {
              setState(() => _found = true);
              await _cameraController!.stopImageStream();
              _showSuccessDialog();
              return;
            }
          }
        }
      } catch (e) {
        // Ignore frame processing errors
      }
      _isProcessing = false;
    });
  }

  InputImage? _convertCameraImage(CameraImage image) {
    final camera = _cameraController!.description;
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  void _showSuccessDialog() {
    final isArabic = widget.language == 'ar';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Color(0xFFB4D3D9)),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'وجدتها! 🎉' : 'You found it! 🎉',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? _targetCard!.wordArabic : _targetCard!.wordEnglish,
              style: const TextStyle(fontSize: 22, color: Color(0xFFBDA6CE)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickNewTarget();
                    _startImageStream();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4D3D9)),
                  child: Text(
                    isArabic ? 'كلمة جديدة' : 'Next Word',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBDA6CE)),
                  child: Text(
                    isArabic ? 'الرئيسية' : 'Home',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playTargetWord() async {
    if (_targetCard == null) return;
    final path = widget.language == 'ar'
        ? _targetCard!.audioArabicPath
        : _targetCard!.audioEnglishPath;
    await _player.play(AssetSource(path.replaceFirst('assets/', '')));
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _player.dispose();
    _labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';

    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _targetCard == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2EAE0),
        body: Center(
            child: CircularProgressIndicator(color: Color(0xFFBDA6CE))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(isArabic ? 'أرني!' : 'Show Me!'),
        backgroundColor: const Color(0xFFB4D3D9),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Target word
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFB4D3D9).withOpacity(0.15),
            child: Column(
              children: [
                Text(
                  isArabic
                      ? 'هل يمكنك أن تجد: ${_targetCard!.wordArabic}?'
                      : 'Can you find: ${_targetCard!.wordEnglish}?',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: _playTargetWord,
                  icon: const Icon(Icons.volume_up,
                      size: 32, color: Color(0xFFB4D3D9)),
                ),
              ],
            ),
          ),

          // Camera
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CameraPreview(_cameraController!),
                ),
                // Hint overlay
                if (_showHint)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _targetCard!.imagePath,
                            height: 150,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, size: 80),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                setState(() => _showHint = false),
                            child: Text(
                              isArabic ? 'إخفاء' : 'Hide',
                              style: const TextStyle(
                                  color: Color(0xFFBDA6CE)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showHint = true),
                  icon: const Icon(Icons.lightbulb),
                  label: Text(isArabic ? 'تلميح' : 'Hint'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBDA6CE),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: Text(isArabic ? 'الرئيسية' : 'Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4D3D9),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}