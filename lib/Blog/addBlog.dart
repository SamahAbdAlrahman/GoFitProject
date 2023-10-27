import 'dart:convert';
import 'package:gofit_frontend/CustumWidget/OverlayCard.dart';
import 'package:gofit_frontend/Model/addBlogModels.dart';
import 'package:gofit_frontend/NetworkHandler.dart';
import 'package:gofit_frontend/Pages/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddBlog extends StatefulWidget {
  AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  IconData iconphoto = Icons.image;
  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(248, 96, 2, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (_imageFile != null && _globalkey.currentState!.validate()) {
                try {
                  final imageFile = _imageFile!;
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) => OverlayCard(
                      key: Key('unique_key'),
                      imagefile: imageFile,
                      title: _title.text,
                    ),
                  );
                } catch (e) {
                  // Handle any exceptions that might occur
                  print("Error: $e");
                }
              }
            },
            child: Text(
              "Preview",
              style: TextStyle(fontSize: 18, color:
              Colors.white, fontWeight: FontWeight.w400),
            ),
          )


        ],
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),  SizedBox(
              height: 20,
            ),
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 30,
            ),
            addButton(),
          ],
        ),
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <= 100";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color:        Color.fromRGBO(248, 96, 2, 1.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color:        Color.fromRGBO(248, 96, 2, 1.0),
            ),
            onPressed: takeCoverPhoto,
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color:        Color.fromRGBO(248, 96, 2, 1.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          labelText: "Provide Body for Your Blog",
        ),
        maxLines: null,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        if (_imageFile != null && _globalkey.currentState!.validate()) {
          AddBlogModel addBlogModel =
          AddBlogModel(body: _body.text, title: _title.text);
          var response = await networkHandler.post1(
              "/blogpost/Add", addBlogModel.toJson());
          print(response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            var imageResponse = await networkHandler.patchImage(
                "/blogpost/add/coverImage/$id", _imageFile!.path);
            print(imageResponse.statusCode);
            if (imageResponse.statusCode == 200 ||
                imageResponse.statusCode == 201) {
              //
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => HomePage(role: role,)),
              //       (route) => false,
              // );
            }
          }
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color:        Color.fromRGBO(248, 96, 2, 1.0),
          ),
          child: Center(
            child: Text(
              "Add Blog",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
  void takeCoverPhoto() async {
    final coverPhoto = await _picker.pickImage(source: ImageSource.gallery);
    if (coverPhoto != null) {
      setState(() {
        _imageFile = PickedFile(coverPhoto.path);
        iconphoto = Icons.check_box;
      });
    }
  }


}
