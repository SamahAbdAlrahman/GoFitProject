import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gofit_frontend/NetworkHandler.dart';
import 'package:gofit_frontend/Pages/HomePage.dart';
import 'package:gofit_frontend/Screen/posts_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatProfile extends StatefulWidget {
  CreatProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreatProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  XFile? _imageFile;


  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey), // Set the color of the back icon to grey
      )
,

      body: Form(

        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            SizedBox(height: 22),
            imageProfile(),
            SizedBox(height: 20),
            nameTextField(),
            SizedBox(height: 20),
            professionTextField(),
            SizedBox(height: 20),
            dobField(),
            SizedBox(height: 20),
            titleTextField(),
            SizedBox(height: 20),
            aboutTextField(),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalkey.currentState!.validate()) {
                  // Validation passed
                  Map<String, String> data = {
                    "name": _name.text,
                    "profession": _profession.text,
                    "DOB": _dob.text,
                    "titleline": _title.text,
                    "about": _about.text,
                  };
                  var response = await networkHandler.post("/profile/add", data);
                  if (response.statusCode == 200 || response.statusCode == 201) {
                    if (_imageFile != null) {
                      var imageResponse = await networkHandler.patchImage(
                          "/profile/add/image", _imageFile!.path);
                      if (imageResponse.statusCode == 200) {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false);
                      } else {
                        // Handle the case where image upload failed
                        // Add appropriate error handling
                      }
                    } else {
                      // Handle the case where no image is selected
                      // Add appropriate error handling
                      setState(() {
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (route) => false);
                    }
                  } else {
                    // Handle the case where profile creation failed
                    // Add appropriate error handling
                  }
                }
              },
              child: Container(
                height: 55,
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
                    "Create Profile",
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
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/img/d2.png")
                : FileImage(File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
            bottom: 15.0,
            right: 15,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Color.fromRGBO(255, 255, 255, 0.8),
                // color: Colors.grey,
                // Use your color code here
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black54,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  // void takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   setState(() {
  //     _imageFile =
  //     (pickedFile != null ? File(pickedFile.path) : null) as PickedFile?;
  //   });
  // }
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile ;
    });
  }


  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "Name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey, // Use your color code here
        ),
        labelText: "Name",

        hintText: "Your name...",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value!.isEmpty) return "Education can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.school,
          color: Colors.grey, // Use your color code here
        ),
        labelText: "Education",

        hintText: "Your education...",
      ),
    );
  }

  Widget dobField() {
    return DateTimePicker(
      type: DateTimePickerType.date,
      dateMask: 'dd/MM/yyyy',
      controller: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.date_range,
          color: Colors.grey, // Use your color code here
        ),
        labelText: "Date Of Birth",

      ),
      onChanged: (val) {
        print(val);
      },
      validator: (value) {
        if (value!.isEmpty) return "Date of birth can't be empty";
        return null;
      },
      onSaved: (value) {
        _dob.text = value!;
      },
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value!.isEmpty) return "Bio can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person_pin,
          color: Colors.grey, // Use your color code here
        ),
        labelText: "Bio",

        hintText: "Self-description...",
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value!.isEmpty) return "About can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA570E), // Use your color code here
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person_pin,
          color: Colors.grey, // Use your color code here
        ),
        labelText: "About",
        hintText: "About",
      ),
    );
  }
}