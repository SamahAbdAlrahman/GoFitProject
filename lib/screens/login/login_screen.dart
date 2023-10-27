import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gofit_frontend/screens/login/signup_screen.dart';

import '../../Coach/MainTabView3.dart';
import '../../NetworkHandler.dart';
import '../../Nutritionist/MainTabView4.dart';
import '../../Pages/ForgetPassword.dart';
import '../../Pages/HomePage.dart';
import '../home/menu_view.dart';
import '../main_tab/mainTanloging.dart';

class LoginScreen extends StatefulWidget {
  // LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  late String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();


  Future<void> loginUser(String username, String password) async {
    // تحقق من نوع المستخدم بناءً على الاسم المدخل
    String userType = "Default"; // النوع الافتراضي

    if (RegExp(r'^[a-zA-Z]+$').hasMatch(username)) {
      //Login Logic start here
      Map<String, String> data = {
        "username": _usernameController.text,
        "password": passwordController.text,
      };
      var response = await networkHandler.post('/user/login', data);
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Map<String, dynamic> output = json.decode(response.body);
        print(output["token"]);
        await storage.write(key: "token", value: output["token"]);
        setState(() {
          validate = true;
          circular = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              // builder: (context) => MenuView(),
              builder: (context) => MainTabView2(),
            ),
                (route) => false);
      } else {
        String output = json.decode(response.body);
        setState(() {
          validate = false;
          errorText = output;
          circular = false;
        });
      }
    }
    else if (RegExp(r'^119\d+').hasMatch(username)) {
      // إذا بدأ الاسم بـ 119 ويحتوي على أرقام
      userType = "Coach";
      Map<String, String> data = {
        "username": username,
        "password": password,
        "employeeType": userType, // ارسل نوع المستخدم مع البيانات
      };

      var response = await networkHandler.post('/employee/login', data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> output = json.decode(response.body);
        print(output["token"]);
        await storage.write(key: "token", value: output["token"]);
        setState(() {
          validate = true;
          circular = false;
        });

        // اختبار نوع المستخدم وتوجيهه إلى الصفحة المناسبة
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => maintabCoach(),
          ),
              (route) => false,
        );
      }
      else {
        String output = json.decode(response.body);
        setState(() {
          validate = false;
          errorText = output;
          circular = false;
        });
      }
    }
    else if (RegExp(r'^120\d+').hasMatch(username)) {
        // إذا بدأ الاسم بـ 120 ويحتوي على أرقام
        userType = "Nutritionist";

        Map<String, String> data = {
          "username": username,
          "password": password,
          "employeeType": userType, // ارسل نوع المستخدم مع البيانات
        };

        var response = await networkHandler.post('/employee/login', data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> output = json.decode(response.body);
          print(output["token"]);
          await storage.write(key: "token", value: output["token"]);
          setState(() {
            validate = true;
            circular = false;
          });

          // اختبار نوع المستخدم وتوجيهه إلى الصفحة المناسبة

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => maintabNutritionist(),
            ),
                (route) => false,
          );
        }
        else {
          String output = json.decode(response.body);
          setState(() {
            validate = false;
            errorText = output;
            circular = false;
          });
        }
      }
 }
  // Future<void> loginUser(String username, String password) async {
  //   //Login Logic start here
  //   Map<String, String> data = {
  //     "username": _usernameController.text,
  //     "password": passwordController.text,
  //   };
  //   var response = await networkHandler.post('/user/login', data);
  //   if (response.statusCode == 200 ||
  //       response.statusCode == 201) {
  //     Map<String, dynamic> output = json.decode(response.body);
  //     print(output["token"]);
  //     await storage.write(key: "token", value: output["token"]);
  //     setState(() {
  //       validate = true;
  //       circular = false;
  //     });
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           // builder: (context) => MenuView(),
  //           builder: (context) =>  MainTabView2(),
  //         ),
  //             (route) => false);
  //   } else {
  //     String output = json.decode(response.body);
  //     setState(() {
  //       validate = false;
  //       errorText = output;
  //       circular = false;
  //     });
  //   }
  // }
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
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
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              key: _globalkey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(300),
                  ),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 160),
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
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        hintText: "User Name",
                                        hintStyle: TextStyle(
                                            color: Colors.grey),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color.fromRGBO(190, 194, 203,
                                              0.4823529411764706),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Colors.grey),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Toggle password visibility icon
                                            passwordController.text.isEmpty
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              // Toggle password visibility
                                              passwordController.text.isEmpty
                                                  ?
                                              passwordController.text = ' '
                                                  : passwordController.text =
                                              '';
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Row(
                            // SizedBox(width: 20),
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     // InkWell(
                            //     //   onTap: () {
                            //     //     Navigator.push(
                            //     //         context,
                            //     //         MaterialPageRoute(
                            //     //             builder: (context) => ForgotPasswordPage()));
                            //     //   },
                            //     //   child: Text(
                            //     //     "Forgot Password ?",
                            //     //     style: TextStyle(
                            //     //       color: Colors.black54,
                            //     //       fontSize: 15,
                            //     //       fontWeight: FontWeight.bold,
                            //     //     ),
                            //     //   ),
                            //     // ),
                            //     SizedBox(width: 20),
                            //
                            //   ],
                            // ),
                            SizedBox(height: 40),
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 40),

                            GestureDetector(
                              onTap: () async {
                                try {
                                  await loginUser(
                                    _usernameController.text,
                                    passwordController.text,
                                  );
                                } catch (e) {
                                  print("Login failed: $e");
                                }
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(246, 87, 14, 1.0),
                                ),
                                child: Center(
                                  child: circular
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                      : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 80),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          NewAccountScreen()));
                                },
                                child: Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.black54),
                                ),
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


          ],
        ),
      ),
    );

}


}
