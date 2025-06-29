import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../constants/colors.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../models/horse.dart';
import 'analysis_result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage;
  bool _isAnalyzing = false;
  String? _selectedHorseId;
  List<Horse> _horses = [];

  @override
  void initState() {
    super.initState();
    _loadHorses();
  }

  Future<void> _loadHorses() async {
    final horses = await StorageService.instance.getHorses();
    setState(() {
      _horses = horses;
      if (horses.isNotEmpty && _selectedHorseId == null) {
        _selectedHorseId = horses.first.id;
      }
    });
  }

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture image: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_capturedImage == null || _selectedHorseId == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final bytes = await _capturedImage!.readAsBytes();
      
      if (!AIService.instance.validateImage(bytes)) {
        throw Exception('Invalid image format or size');
      }

      final result = await AIService.instance.analyzeTeethImage(
        horseId: _selectedHorseId!,
        imageBytes: bytes,
        imagePath: _capturedImage!.path,
      );

      await StorageService.instance.saveAnalysisResult(result);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(result: result),
        ),
      );

      setState(() {
        _capturedImage = null;
        _isAnalyzing = false;
      });

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Teeth Photo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (_horses.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                value: _selectedHorseId,
                decoration: const InputDecoration(
                  labelText: 'Select Horse',
                  border: OutlineInputBorder(),
                ),
                items: _horses.map((horse) {
                  return DropdownMenuItem<String>(
                    value: horse.id,
                    child: Text('${horse.name} (${horse.breed})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHorseId = value;
                  });
                },
              ),
            ),
          ],
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _capturedImage == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 64, color: AppColors.textSecondary),
                          SizedBox(height: 16),
                          Text('Position camera to capture horse\'s front teeth clearly'),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _capturedImage!.path,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Failed to load image'),
                          );
                        },
                      ),
                    ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: _capturedImage == null
                ? Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _captureImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final image = await _picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _capturedImage = image;
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Choose from Gallery'),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _capturedImage = null;
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retake'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _selectedHorseId != null && !_isAnalyzing
                              ? _analyzeImage
                              : null,
                          icon: _isAnalyzing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.analytics),
                          label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze'),
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
