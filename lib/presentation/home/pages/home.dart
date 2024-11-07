// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecognition/common/widgets/tabs.dart';
// import 'package:lecognition/models/disease.dart';
import 'package:lecognition/presentation/bookmark/pages/bookmarked.dart';
import 'package:lecognition/presentation/home/bloc/disease_cubit.dart';
import 'package:lecognition/presentation/home/bloc/disease_state.dart';
import 'package:lecognition/widgets/diseaseCard.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiseaseCubit()..getAllDiseases(),
      child: BlocBuilder<DiseaseCubit, DiseaseState>(
        builder: (context, state) {
          return Skeletonizer(
            enabled: state is DiseasesLoading,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width / 2.2,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: AutoSizeText(
                                  "Selamat Datang Lukman!",
                                  minFontSize: 35,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Informasi'),
                                            content: const Text(
                                                'Gunakan menu diagnozer untuk mendeteksi penyakit tanaman mangga berdasarkan daunnya.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.3),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TabsScreen(index: 1),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.camera_alt_outlined,
                                          color: Colors.white, size: 50),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookmarkedScreen(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is DiseasesFailureLoad)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                if (state is DiseasesLoaded)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final disease = state.diseases[index];
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 25.0 : 15.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: index == 0 ? 10 : 10,
                              ),
                              child: DiseaseCard(
                                disease: disease,
                              ),
                            ),

                            // Menambahkan Divider sebagai garis bawah
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary, // Warna garis bawah
                              thickness: 1.0, // Ketebalan garis
                              height: 1.0, // Jarak vertikal garis
                            ),
                          ],
                        );
                      },
                      childCount: state.diseases.length,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}