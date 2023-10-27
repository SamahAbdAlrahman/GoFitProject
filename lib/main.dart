import 'package:flutter/material.dart';
import 'package:gofit_frontend/screens/User/subscribtion.dart';
import 'Admin/EditExcerciseClasses.dart';
import 'Admin/admin.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/signup_screen.dart';
import 'package:gofit_frontend/screens/main_tab/select_view.dart';
import 'package:gofit_frontend/screens/main_tab/main_tab_view.dart';
import 'package:gofit_frontend/screens/meal_planner/meal_planner_view.dart';
import 'package:gofit_frontend/screens/workout_tracker/workout_tracker_view.dart';
import 'package:gofit_frontend/screens/workout_tracker/BeginnerExercises.dart';
import 'package:gofit_frontend/screens/login/on_boarding_view.dart';
import 'package:gofit_frontend/screens/home/menu_view.dart';
import 'package:gofit_frontend/Blog/addBlog.dart';
import 'package:gofit_frontend/Pages/HomePage.dart';
import 'package:gofit_frontend/Profile/MainProfile.dart';
import 'package:flutter/material.dart';
import 'Pages/LoadingPage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       // home:  DrawerDemo(),
      // home: MenuView(),
      home: LoginScreen(),
    );

  }
}
