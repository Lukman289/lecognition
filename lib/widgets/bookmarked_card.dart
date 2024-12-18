import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecognition/core/configs/assets/app_images.dart';
import 'package:lecognition/domain/bookmark/entities/bookmark.dart';
import 'package:lecognition/presentation/bookmark/bloc/bookmark_cubit.dart';
import 'package:lecognition/presentation/home/pages/disease.dart';

class BookmarkedCard extends StatefulWidget {
  final BookmarkEntity disease;

  BookmarkedCard({
    super.key,
    required this.disease,
  });

  @override
  _BookmarkedCardState createState() => _BookmarkedCardState();
}

class _BookmarkedCardState extends State<BookmarkedCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.disease.disease?.isBookmarked);
    print(AppImages.basePathDisease +
        widget.disease.disease!.id.toString() +
        ".jpg");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiseaseScreen(
                  disease: widget.disease.disease!,
                ),
              ),
            ).then((_) {
              BlocProvider.of<BookmarkCubit>(context)
                  .getAllBookmarkedDiseases();
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 3.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5.0,
                    right: 5.0,
                    top: 5.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: Image.asset(
                      AppImages.basePathDisease +
                          widget.disease.disease!.id.toString() +
                          ".jpg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 7,
                      errorBuilder: (context, error, stackTrace) {
                        print("Error loading image: $error");
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.disease.disease?.name ?? 'Unknown Disease'}",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "${widget.disease.disease?.detail?.desc ?? 'It must be a disease description'}",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
