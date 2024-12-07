import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lecognition/common/widgets/appbar.dart';
import 'package:lecognition/data/diagnozer/models/get_diagnoze_result_params.dart';
import 'package:lecognition/presentation/diagnozer/bloc/diagnosis_state.dart';
import 'package:lecognition/presentation/diagnozer/bloc/diagnozer_cubit.dart';
import 'package:lecognition/presentation/home/pages/home.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/disease/entities/disease.dart';
import '../../../domain/disease/entities/disease_detail.dart';
import '../../disease/pages/disease.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({
    super.key,
    required this.photo,
    required this.plantName, // New parameter
    // required this.diseaseDescription, // New parameter
  });

  final XFile photo;
  final String plantName;
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // DiseaseEntity ds = diseases[0];
  // final double percentage = Random().nextDouble();
  bool isShowPercentage = false;

  DiseaseEntity _findDisease(int diseaseId) {
    print("Disease ID: $diseaseId");
    for (var disease in HomeScreen.localDiseasesData) {
      print("Disease ID Looping Now ${disease.id} == $diseaseId ?");
      if (disease.id == diseaseId) {
        return disease;
      }
    }
    final DiseaseEntity returnedDisease = DiseaseEntity(
      id: 5,
      name: 'Penyakit Tidak Diketahui',
      desc: 'Penyakit ini tidak ditemukan dalam database kami.',
    );
    returnedDisease.detail = diseaseDetails.firstWhere(
      (detail) => detail.id == returnedDisease.id,
      orElse: null,
    );
    return returnedDisease;
  }

  void saveDiagosisResult(
      int idResultedDisease, double percentageResultedDisease) async {
    print("Resulted Disease: $idResultedDisease $percentageResultedDisease%");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? savedResults = prefs.getStringList('diagnosis_result') ?? [];
    savedResults.add(idResultedDisease.toString());
    await prefs.setStringList('diagnosis_result', savedResults);
    print('Saved results: $savedResults');

    List<String>? savedPercentages =
        prefs.getStringList('diagnosis_percentage') ?? [];
    savedPercentages.add(percentageResultedDisease.toString());
    await prefs.setStringList('diagnosis_percentage', savedPercentages);
    print('Saved percentages: $savedPercentages');
  }

  void showPercentage() async {
    print('Show Percentage ${isShowPercentage}');
    setState(() {
      isShowPercentage = !isShowPercentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoImg = File(widget.photo.path);
    if (HomeScreen.localDiseasesData.isEmpty) {
      return Center(
        child: Text(
          "Data penyakit tidak ditemukan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Scaffold(
      appBar: AppBarWidget(title: 'Hasil Diagnosis'),
      body: BlocProvider<DiagnozerCubit>(
        create: (context) => DiagnozerCubit()
          ..getDiagnosis(
            GetDiagnosisParams(
              imageFile: widget.photo,
            ),
          ),
        child: BlocBuilder<DiagnozerCubit, DiagnosisState>(
          builder: (context, state) {
            if (state is DiagnosisLoading) {
              // print("Persentase: $persentase");
              //   print("Disease: ${state.diagnosis.disease}");
              print(
                "Path gambar: ${widget.photo.path}",
              );
              print(
                "Apakah file ada? ${File(
                  widget.photo.path,
                ).existsSync()}",
              );
              return Center(
                child: SpinKitSquareCircle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 50.0,
                ),
              );
            }
            if (state is DiagnosisFailureLoad) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.black,
                    ),
                    subtitle: Text(
                      "maaf! proses deteksi gagal :(",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Ambil Gambar Ulang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ));
            }
            if (state is DiagnosisLoaded) {
              try {
                final double? persentase = state.diagnosis.accuracy;
                print("Persentase: $persentase");
                print("Disease: ${state.diagnosis.disease}");
                print("Path gambar: ${widget.photo.path}");
                print(
                  "Apakah file ada? ${File(
                    widget.photo.path,
                  ).existsSync()}",
                );
                saveDiagosisResult(state.diagnosis.disease!, persentase!);
                return ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  children: [
                    Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(photoImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 1.2,
                      ),
                      Positioned(
                        bottom: 30,
                        right: 20,
                        child: Column(
                          children: [
                            if (isShowPercentage)
                              AnimatedOpacity(
                                opacity: isShowPercentage ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 5000),
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 5000),
                                  curve: Curves.easeInOut,
                                  child: isShowPercentage
                                      ? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: CircularPercentIndicator(
                                            radius: 45.0,
                                            lineWidth: 13.0,
                                            percent: persentase,
                                            animation: true,
                                            animationDuration: 1000,
                                            center: Text(
                                              "${(persentase * 100).round()}%",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            progressColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                showPercentage();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Akurasi",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    Icon(
                                      isShowPercentage
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_drop_up,
                                      size: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          state.diagnosis.disease == 1
                              ? "Tanamanmu Sehat"
                              : "Tanamanmu Terkena Penyakit",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: state.diagnosis.disease == 1
                            ? Text(
                                "Tidak ada penyakit terdeteksi",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            : Text(
                                "Disease ${state.diagnosis.disease.toString()}",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiseaseScreen(
                              disease: _findDisease(state.diagnosis.disease!),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10),
                          child: Center(
                            child: Text(
                              'Detail',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } catch (e) {
                return Center(
                  child: Text(
                    "Terjadi kesalahan saat menampilkan hasil diagnosis $e",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}
