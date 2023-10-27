import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_screen.dart';

class NewAccountScreen extends StatefulWidget {
  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  //

  //
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  // TextEditingController aboutController = TextEditingController();
  // File? imageFile;
  // TextEditingController eduController = TextEditingController();
  // TextEditingController heightController = TextEditingController();
  // TextEditingController weightController = TextEditingController();
//
//

  //
  bool _isNotValidate = false;

  void registerUser() async {


    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text,
        "username": usernameController.text,
        // "about": aboutController.text,
        // "img": imageFile?.path ?? "",
        //
        // "edu": eduController.text,
        // "Height": heightController.text,
        // "weight": weightController.text,
      };
      // final Uri apiUrl = Uri.parse('http://192.168.0.108:3000/register');
      final Uri apiUrl = Uri.parse('http://192.168.0.111:5000/user/register');
      http://localhost:5000/user/register
      var response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(""),
              content: Text("Create your account successfully", style: TextStyle(color: Colors.black54),),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("Something Went Wrong. Status code: ${response.statusCode}");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  // Future<void> selectImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromRGBO(248, 96, 2, 1.0),
              Color.fromRGBO(190, 57, 33, 1.0),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 17),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(100),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(35),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 89),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(80, 78, 78, 1.0),
                                blurRadius: 30,
                                offset: Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: Icon(Icons.email), // Fix icon import
                                    border: InputBorder.none, // Fix InputBorder
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(

                                    labelText: "Password",
                                    prefixIcon: Icon(Icons.lock), // Fix icon import
                                    border: InputBorder.none, // Fix InputBorder
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                child: TextField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    prefixIcon: Icon(Icons.person), // Fix icon import
                                    border: InputBorder.none, // Fix InputBorder
                                  ),
                                ),
                              ),
                              // Container(
                              //   alignment: Alignment.center,
                              //   child: imageFile == null
                              //       ? Text("No image selected.")
                              //       : CircleAvatar(
                              //     radius: 50,
                              //     backgroundImage: FileImage(imageFile!),
                              //   ),
                              // ),
                              // SizedBox(height: 20),
                              // GestureDetector(
                              //   onTap: () {
                              //     selectImage();
                              //   },
                              //   child: Container(
                              //     height: 30,
                              //     decoration: BoxDecoration(
                              //       color: Colors.blue,
                              //       borderRadius: BorderRadius.circular(5),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         "Select Image",
                              //         style: TextStyle(
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   decoration: BoxDecoration(
                              //     border: Border(
                              //       bottom: BorderSide(color: Colors.grey[200]!),
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: aboutController,
                              //     decoration: InputDecoration(
                              //       labelText: "About",
                              //       prefixIcon: Icon(Icons.info), // Fix icon import
                              //       border: InputBorder.none, // Fix InputBorder
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   decoration: BoxDecoration(
                              //     border: Border(
                              //       bottom: BorderSide(color: Colors.grey[200]!),
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: eduController,
                              //     decoration: InputDecoration(
                              //       labelText: "Education",
                              //       prefixIcon: Icon(Icons.school), // Fix icon import
                              //       border: InputBorder.none, // Fix InputBorder
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   decoration: BoxDecoration(
                              //     border: Border(
                              //       bottom: BorderSide(color: Colors.grey[200]!),
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: heightController,
                              //     decoration: InputDecoration(
                              //       labelText: "Height",
                              //       prefixIcon: Icon(Icons.height), // Fix icon import
                              //       border: InputBorder.none, // Fix InputBorder
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   decoration: BoxDecoration(
                              //     border: Border(
                              //       bottom: BorderSide(color: Colors.grey[200]!),
                              //     ),
                              //   ),
                              //   child: TextField(
                              //     controller: weightController,
                              //     decoration: InputDecoration(
                              //       labelText: "Weight",
                              //       prefixIcon: Icon(Icons.line_weight), // Fix icon import
                              //       border: InputBorder.none, // Fix InputBorder
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60),
                        GestureDetector(
                          onTap: () {
                            registerUser();
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromRGBO(246, 87, 14, 1.0),
                            ),
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

