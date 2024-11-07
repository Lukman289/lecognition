import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lecognition/common/widgets/appbar.dart';
import 'package:lecognition/presentation/history/pages/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriScreen extends StatefulWidget {
  const HistoriScreen({super.key});

  @override
  State<HistoriScreen> createState() => _HistoriScreenState();
}

class _HistoriScreenState extends State<HistoriScreen> {
  List<String> _imagePaths = [];
  List<String> _diseaseNames = []; // List for disease names
  List<String> _diseaseDescriptions = []; // List for disease descriptions

  @override
  void initState() {
    super.initState();
    _loadData(); // Load all relevant data
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedImages = prefs.getStringList('diagnosis_images') ?? [];
    List<String>? savedNames = prefs.getStringList('diagnosis_names') ?? [];
    List<String>? savedDescriptions = prefs.getStringList('diagnosis_descriptions') ?? [];

    setState(() {
      _imagePaths = savedImages;
      _diseaseNames = savedNames;
      _diseaseDescriptions = savedDescriptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Histori Diagnosa'), // Use custom appbar
      body: _imagePaths.isEmpty
          ? const Center(
        child: Text('Belum ada diagnosis yang tersimpan.'),
      )
          : Scrollbar(
        interactive: true,
        thickness: 3,
        radius: const Radius.circular(5),
        child: ListView.builder(
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to detail screen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultHistoryScreen(
                      imagePath: _imagePaths[index],
                      diseaseName: _diseaseNames[index], // Pass disease name
                      diseaseDescription: _diseaseDescriptions[index], // Pass disease description
                      diagnosisNumber: index,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // 16px padding from all sides
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                        children: [
                          // Image placed on the top-left of the card
                          Hero(
                            tag: _imagePaths[index], // Unique tag for each image
                            child: Image.file(
                              File(_imagePaths[index]),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10), // Space between image and text
                          // Column for text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '#${index + 1} ${_diseaseNames[index]}', // Diagnosis name
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '21-10-2024', // Static date, replace with actual if needed
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _diseaseDescriptions[index], // Disease description
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}