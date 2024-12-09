import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecognition/presentation/history/bloc/history_cubit.dart';
import 'package:lecognition/presentation/history/bloc/history_state.dart';
import 'package:lecognition/widgets/appbar.dart';
import 'package:lecognition/domain/disease/entities/disease.dart';
import 'package:lecognition/presentation/history/pages/history_detail.dart';
import 'package:lecognition/presentation/home/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriScreen extends StatefulWidget {
  const HistoriScreen({super.key});

  @override
  State<HistoriScreen> createState() => _HistoriScreenState();
}

class _HistoriScreenState extends State<HistoriScreen> {
  List<String> _imagePaths = [];
  // List<String> _plantNames = [];
  // List<String> _diseaseId = []; // List for disease names
  // List<String> _percentages = []; // List for disease percentages
  // List<String> _diseaseDescriptions = []; // List for disease descriptions

  @override
  void initState() {
    super.initState();
    _loadData(); // Load all relevant data
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedImages = prefs.getStringList('diagnosis_images') ?? [];
    // List<String>? savedPlantNames = prefs.getStringList('plant_names') ?? [];
    // List<String>? savedResults = prefs.getStringList('diagnosis_result') ?? [];
    // List<String>? savedPercentages =
    //     prefs.getStringList('diagnosis_percentage') ?? [];

    setState(() {
      _imagePaths = savedImages;
      // _plantNames = savedPlantNames;
      // _diseaseId = savedResults;
      // _percentages = savedPercentages;
      // _diseaseDescriptions = savedDescriptions;
    });

    print('Loaded image paths: $_imagePaths');
    // print('Loaded plant names: $_plantNames');
    // print('Loaded resulted disease id: $_diseaseId');
    // print('Loaded resulted disease percentage: $_percentages');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..getUserHistories(),
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HistoryFailureLoad) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is HistoryLoaded) {
            print('Loaded user histories: ${state.userHistories}');
            return Scaffold(
              appBar:
                  AppBarWidget(title: 'Riwayat Diagnosis'), // Use custom appbar
              body: _imagePaths.isEmpty
                  ? const Center(
                      child: Text('Belum ada diagnosis yang tersimpan.'),
                    )
                  : Scrollbar(
                      interactive: true,
                      thickness: 3,
                      radius: const Radius.circular(5),
                      child: ListView.builder(
                        itemCount: state.userHistories.length,
                        itemBuilder: (context, index) {
                          // DiseaseEntity ds = HomeScreen.localDiseasesData[0];
                          // DiseaseEntity _findDisease() {
                          //   for (var disease in HomeScreen.localDiseasesData) {
                          //     if (disease.id == int.parse(_diseaseId[index])) {
                          //       ds = disease;
                          //       break;
                          //     }
                          //   }
                          //   return ds;
                          // }

                          // ds = _findDisease();
                          // print('Disease: ${ds.name}');
                          return GestureDetector(
                            onTap: () {
                              // Navigate to detail screen when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultHistoryScreen(
                                    imagePath: _imagePaths[index],
                                    disease: state.userHistories[index].disease!,
                                    plantName: state.userHistories[index].tree!.desc!,
                                    percentage:
                                        double.parse(state.userHistories[index].accuracy!),
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
                                padding: const EdgeInsets.all(
                                    16.0), // 16px padding from all sides
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Align items to the top
                                      children: [
                                        // Image placed on the top-left of the card
                                        Hero(
                                          tag: _imagePaths[
                                              index], // Unique tag for each image
                                          child: Image.file(
                                            File(_imagePaths[index]),
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Space between image and text
                                        // Column for text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Diagnosis #${index + 1}', // Diagnosis name
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              // Text(
                                              //   _diseaseDescriptions[index], // Disease description
                                              //   style: const TextStyle(fontSize: 14),
                                              // ),
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
          return const SizedBox();
        },
      ),
    );
  }
}
