import 'package:flutter/material.dart';
import 'dart:io';
import '../services/image_picker_service.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  final bool useGallery;
  
  const CameraScreen({super.key, this.useGallery = false});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  final ImagePickerService _pickerService = ImagePickerService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.useGallery) {
      _pickFromGallery();
    } else {
      _pickFromCamera();
    }
  }

  Future<void> _pickFromCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final image = await _pickerService.pickImageFromCamera();
    if (image == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Aucune image sélectionnée";
      });
      return;
    }

    await _analyzeImage(image);
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final image = await _pickerService.pickImageFromGallery();
    if (image == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Aucune image sélectionnée";
      });
      return;
    }

    await _analyzeImage(image);
  }

  Future<void> _analyzeImage(File image) async {
    try {
      final result = await _apiService.predict(image);
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(result: result, originalImage: image),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erreur : ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.useGallery ? "Galerie" : "Appareil photo"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Center(
          child: _errorMessage != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_errorMessage!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Retour"),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
