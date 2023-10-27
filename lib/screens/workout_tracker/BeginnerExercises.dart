import 'dart:convert';

import 'package:gofit_frontend/common/colo_extension.dart';
import 'package:gofit_frontend/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:image_picker/image_picker.dart';
class BeginnerExercises extends StatefulWidget {


  @override
  State<BeginnerExercises> createState() => _WorkoutDetailViewState();

}

class _WorkoutDetailViewState extends State<BeginnerExercises> {
  TextEditingController exerciseName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController videoPath = TextEditingController();
  bool _isNotValidate = false;

  Future<List<ExerciseItem>> fetchExercises() async {
    final apiUrl = Uri.parse('http://192.168.111.1:3000/beginnerexercises'); // Replace with your API endpoint
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((exercise) {
        return ExerciseItem(
          exerciseName: exercise['exerciseName'],
          description: exercise['description'],
          videoPath: exercise['videoPath'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
  // final List<ExerciseItem> exerciseItems = [];
  List<ExerciseItem> exerciseItems = [];

// Define a function to show the exercise input dialog



  @override
  void initState() {
    super.initState();
    // Call fetchExercises when the page is opened
    fetchExercises().then((exercises) {
      setState(() {
        exerciseItems = exercises;
      });
    });
  }
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration:
      BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    "assets/img/black_btn.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/complete_workout.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Beginner Exercises",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),

                        ],
                      ),
                      // Add a ListView to display exercise items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: exerciseItems.length,
                        itemBuilder: (context, index) {
                          return ExerciseListItem(
                              exerciseName: exerciseItems[index].exerciseName,
                              description: exerciseItems[index].description,
                              videoPath:exerciseItems[index].videoPath
                          );
                        },
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


// Define a class for exercise items
class ExerciseItem {
  final String exerciseName;
  final String description;
  final String videoPath;

  ExerciseItem({
    required this.exerciseName,
    required this.description,
    required this.videoPath,
  });
}

// Create a widget to display each exercise item
class ExerciseListItem extends StatelessWidget {
  final String exerciseName;
  final String description;
  final String videoPath;

  ExerciseListItem({
    required this.exerciseName,
    required this.description,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.file(
          File(videoPath), // Load the image from the file path
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

