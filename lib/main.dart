import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  String _label = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _tfLiteInit();
  }

  Future<void> _tfLiteInit() async {
    await Tflite.loadModel(
      model: "assets/modelo_clasificacion_animales.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    setState(() {
      _imageFile = imageFile;
    });

    final recognitions = await Tflite.runModelOnImage(
      path: pickedFile.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions == null) {
      print("recognitions is Null");
      return;
    }

    setState(() {
      _confidence = recognitions[0]['confidence'] * 100;
      _label = recognitions[0]['label'].toString();
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clasificador de animales"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          height: 280,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _imageFile == null
                              ? const Text('')
                              : AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                _label,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Accuracy ${_confidence.toStringAsFixed(0)}%",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Camara"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Galeria"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
