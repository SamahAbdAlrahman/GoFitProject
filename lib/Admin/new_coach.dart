import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../configs.dart';
class NewCoach extends StatefulWidget {
  @override
  _NewCoachState createState() => _NewCoachState();
}
class _NewCoachState extends State<NewCoach> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool _isNotValidate = false;
  void registerUser() async {
    if (       passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      var regBody = {
        "username": usernameController.text,
        "password": passwordController.text,
        "employeeType":"Coach",
      };
      final Uri apiUrl = Uri.parse(registeremployee);
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
              content: Text("Create account successfully", style: TextStyle(color: Colors.black54),),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LoginScreen()),
                    // );
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
                        GestureDetector(
                          onTap: () {
                            // رجوع إلى الصفحة السابقة
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.arrow_back, color: Colors.black),
                                Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
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

