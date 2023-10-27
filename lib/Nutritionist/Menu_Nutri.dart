import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gofit_frontend/Blog/addBlog.dart';
import 'package:gofit_frontend/Screen/posts_view.dart';
import 'package:gofit_frontend/NetworkHandler.dart';
import 'package:gofit_frontend/Profile/ProfileScreen.dart';
import 'package:gofit_frontend/screens/login/on_boarding_view.dart';
import '../../Blog/Blogs.dart';
import '../../Profile/MainProfile.dart';
import '../../common_widget/menu_cell.dart';
import 'package:gofit_frontend/screens/home/running_view.dart';
import 'package:gofit_frontend/screens/home/schedule_view.dart';

class MenuNutrui extends StatefulWidget {
  const MenuNutrui({Key? key}) : super(key: key);

  @override
  _MenuNutruiState createState() => _MenuNutruiState();
}

class _MenuNutruiState extends State<MenuNutrui> {
  int currentState = 0;
  List<Widget> widgets = [MenuNutrui(), ProfileScreen()];
  List<String> titleString = ["Coach Page", "Profile Page"];
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  String username = "";
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.deepOrange,
      borderRadius: BorderRadius.circular(50),
    ),
  );
  List menuArr = [

    {"name": "Add Meal Plan", "image": "assets/img/menu_meal_plan.png", "tag": "1"},
    {"name": "Add Tips", "image": "assets/img/menu_tips.png", "tag": "2"},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    // super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if (response["status"] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      setState(() {
        profilePhoto = Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text("$username"),
                ],
              ),
            ),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => PostsView(),));
                // Blogs
              },
            ),
            ListTile(
              title: Text("New Story"),
              trailing: Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: Text("New Post"),
              trailing: Icon(Icons.add),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddBlog()));
              },
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey, // Set the color of the Drawer icon to grey
        ),
        backgroundColor:        Colors.white,
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications    ,
            color: Colors.grey,),
              onPressed: () {}),
        ],
      ),

      body:
      // widgets[currentState],
      Container(
        color: Colors.white,
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: menuArr.length,
          itemBuilder: ((context, index) {
            var mObj = menuArr[index] as Map? ?? {};
            return MenuCell(
              mObj: mObj,
              onPressed: () {
                switch (mObj["tag"].toString()) {
                  case "1":
                  // Handle
                    break;
                  case "2":
                  // Handle
                    break;

                  default:
                }
              },
            );
          }),
        ),
      ),
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingView()),
            (route) => false);
  }
}



