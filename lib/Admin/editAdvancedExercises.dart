import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gofit_frontend/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../configs.dart';
class AdvancedExercises extends StatefulWidget {


  @override
  State<AdvancedExercises> createState() => _WorkoutDetailViewState();

}

class _WorkoutDetailViewState extends State<AdvancedExercises> {
  TextEditingController exerciseName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController videoPath = TextEditingController();
  bool _isNotValidate = false;

  Future<void> registerUser() async {
    if (description.text.isNotEmpty &&
        exerciseName.text.isNotEmpty &&
        videoPath.text.isNotEmpty) {
      final regBody = {
        "exerciseName": exerciseName.text,
        "description": description.text,
        "videoPath": videoPath.text,
      };

      final apiUrl = Uri.parse(addAdvanced); // Update the server URL
      try {
        final response = await http.post(
          apiUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          // Exercise added successfully
          Navigator.of(context).pop(); // Close the dialog
        } else {
          // Handle errors or display an error message
          print('Failed to add exercise: ${response.body}');
          // You can display an error message to the user here
        }
      } catch (error) {
        print('Error: $error');
        // Handle network or other errors
        // You can display an error message to the user here
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }
  Future<List<ExerciseItem>> fetchExercises() async {
    final apiUrl = Uri.parse(Advancedexercises); // Replace with your API endpoint
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((exercise) {
        return ExerciseItem.fromJson(exercise);
      }).toList();
    } else {
      // Handle the error based on the status code
      if (response.statusCode == 404) {
        // Handle a 404 Not Found error
        throw Exception('API endpoint not found');
      } else if (response.statusCode == 401) {
        // Handle a 401 Unauthorized error
        throw Exception('Unauthorized access');
      } else {
        // Handle other errors with a generic message
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    }
  }

  Future<void> deleteExercise(String exerciseId) async {
    final apiUrl = Uri.parse('http://192.168.0.111:5000/Advanced/$exerciseId');
    try {
      final response = await http.delete(
        apiUrl,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 204) {
        // Exercise deleted successfully
        // Update your local list of exercises here
        setState(() {
          exerciseItems.removeWhere((item) => item.id == exerciseId);
        });
      } else if (response.statusCode == 404) {
        // Exercise not found
        print('Exercise with ID $exerciseId not found.');
        // Handle the case where the exercise with the given ID does not exist
      } else {
        // Handle other errors or display an error message
        print('Failed to delete exercise: ${response.statusCode}');
        print('Response body: ${response.body}');
        // You can display an error message to the user here
      }

    } catch (error) {
      print('Error: $error');
      // Handle network or other errors
      // You can display an error message to the user here
    }
  }


  // final List<ExerciseItem> exerciseItems = [];
  List<ExerciseItem> exerciseItems = [];

// Define a function to show the exercise input dialog
  void _showExerciseInputDialog(BuildContext context) async {
    TextEditingController videoPathController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: exerciseName,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),
              TextFormField(
                controller: description,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: videoPath,
                decoration: InputDecoration(labelText: 'Video File Path'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  try {
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      videoPath.text = image.path;
                    } else {
                      print('No image selected.');
                    }
                  } catch (e) {
                    print('Error selecting image: $e');
                  }
                },
                child: Text('Select Image'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await registerUser();
                // Fetch exercises and update the UI
                final exercises = await fetchExercises();
                setState(() {
                  exerciseItems = exercises;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }




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
                  "assets/img/complete_profile.png",
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
                                Text("Advanced Exercises",
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
                            videoPath:exerciseItems[index].videoPath,
                            exerciseId:exerciseItems[index].id,
                            deleteExercise:deleteExercise,
                          );
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Show the exercise input dialog when the button is pressed
                _showExerciseInputDialog(context);
                // Handle the addition of a new exercise item here
                // You can open a dialog or navigate to another screen to add the item
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue, // Customize the button color
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseItem {
  final String id; // Add the ID field
  final String exerciseName;
  final String description;
  final String videoPath;

  ExerciseItem({
    required this.id, // Add the ID field to the constructor
    required this.exerciseName,
    required this.description,
    required this.videoPath,
  });

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    return ExerciseItem(
      id: json['_id']?? '', // Parse and store the ID
      exerciseName: json['exerciseName'],
      description: json['description'],
      videoPath: json['videoPath'],
    );
  }
}
class ExerciseListItem extends StatelessWidget {
  final String exerciseName;
  final String description;
  final String videoPath;
  final String exerciseId;
  final Function(String) deleteExercise;

  ExerciseListItem({
    required this.exerciseName,
    required this.description,
    required this.videoPath,
    required this.exerciseId,
    required this.deleteExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Row(
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.file(
                File(videoPath),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20, // زيادة المساحة بين النصوص
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.blue,
            icon: Icons.delete,
            onTap: () {
              deleteExercise(exerciseId);
            },
          ),
        ],
      ),
    );
  }
}
