import 'package:gofit_frontend/Blog/Blogs.dart';
import 'package:flutter/material.dart';
class PostsView extends StatefulWidget {
  PostsView({Key? key}) : super(key: key);

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      body: SingleChildScrollView(
        child: Blogs(
          key: UniqueKey(), // Pass a unique Key here
          url: "/blogpost/getOtherBlog",
        ),
      ),
    );
  }
}
