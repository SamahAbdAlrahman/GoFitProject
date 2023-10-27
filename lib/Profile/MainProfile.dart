import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:gofit_frontend/Blog/Blogs.dart';
import 'package:gofit_frontend/Model/profileModel.dart';
import 'package:gofit_frontend/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Blog/addBlog.dart';
import '../screens/home/menu_view.dart';
import '../common_widget/tab_button.dart';
import '../screens/login/on_boarding_view.dart';
import 'ProfileScreen.dart';

class MainProfile extends StatefulWidget {
  MainProfile({Key? key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  Widget currentTab = MenuView();
  int currentState = 0;
  List<String> titleString = ["Home Page", "Profile Page"];
  bool circular = true;

  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel(DOB: '_dob',
      about: '_about',
      name: '_name',
      profession: '_profession',
      titleline: '_title');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  void updateProfile() async {
    // Construct the update data
    var updateData = {
      "name": profileModel.name,
      "profession": profileModel.profession,
      "DOB": profileModel.DOB,
      "titleline": profileModel.titleline,
      "about": profileModel.about,
    };

    // Send an HTTP request to update the profile
    var response = await networkHandler.patch("/profile/update", updateData);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData != null && responseData['data'] != null) {
        // Profile updated successfully
        // fetchData(); // Refresh the profile data
        // Navigator.of(context).pop(); //Close the edit dialog
      } else {
        // Handle the error, e.g., display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update profile. Please try again."),
          ),
        );
      }
    } else {
      // Handle the error, e.g., display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey, // Set the color of the Drawer icon to grey
        ),
        backgroundColor: Colors.white,
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications,
            color: Colors.grey,),
              onPressed: () {}),
        ],
      ),
      backgroundColor: Colors.white,


      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: <Widget>[
          IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(Icons.edit, color: Colors.grey,),
            onPressed: () {
              // Display the edit dialog
              _showEditDialog(context);
            },
            color: Colors.black87,
          ),
          head(),

          SizedBox(height: 40),
          Divider(
            thickness: 1.3,
          ),
          otherDetails("Your Name ", profileModel.name),

          Divider(
            thickness: 0.5,
          ),
          otherDetails("About You ", profileModel.about),
          Divider(
            thickness: 0.5,
          ),
          otherDetails("Date of Birth ", profileModel.DOB),
          Divider(
            thickness: 0.5,
          ),
          otherDetails("Education ", profileModel.profession),
          // Divider(
          //   thickness: 1,
          // ),
          SizedBox(height: 159),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              "Your Posts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          )
          ,
          SizedBox(height: 50),
          Blogs(
            url: "/blogpost/getOwnBlog",
          ),
        ],
      ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(
          //   height: 10,
          // ),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(
                  profileModel.username as String),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Text(
            profileModel.username as String,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500
                , color: Colors.black87),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.titleline),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label ",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400, color: Color.fromRGBO(
                255, 77, 0, 1.0),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w400, color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: profileModel.name,
                  onChanged: (value) {
                    setState(() {
                      profileModel.name = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Profession"),
                  initialValue: profileModel.profession,
                  onChanged: (value) {
                    setState(() {
                      profileModel.profession = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "DOB"),
                    initialValue: profileModel.DOB,
                    onChanged: (value) {
                      setState(() {
                        profileModel.DOB = value;
                      });
                    },
                  ),
                ),

                TextFormField(
                  decoration: InputDecoration(labelText: "About"),
                  initialValue: profileModel.about,
                  onChanged: (value) {
                    setState(() {
                      profileModel.about = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Save changes and close the dialog
                updateProfile(); // Update the profile
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: profileModel.DOB != null
          ? DateFormat("yyyy-MM-dd").parse(profileModel.DOB)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null &&
        picked != DateFormat("yyyy-MM-dd").parse(profileModel.DOB)) {
      setState(() {
        profileModel.DOB = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }


}

