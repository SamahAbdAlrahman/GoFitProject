import 'package:gofit_frontend/Model/addBlogModels.dart';
import 'package:gofit_frontend/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  const Blog({
    Key? key,
    required this.addBlogModel,
    required this.networkHandler,
  }) : super(key: key);

  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  bool isCommenting = false;
  TextEditingController commentController = TextEditingController();
  List<String> comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:   Color.fromRGBO(255, 81, 0, 1.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.networkHandler.getImage(widget.addBlogModel.id as String),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.addBlogModel.title as String,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCommenting = true;
                      });
                    },
                    child: Icon(
                      Icons.chat_bubble,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.addBlogModel.comment.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.thumb_up,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.addBlogModel.count.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.share,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.addBlogModel.share.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(16),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(widget.addBlogModel.body as String),
                ),
              ),
            ),
            if (isCommenting)
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                  ),
                ),
              ),
            if (isCommenting)
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromRGBO(246, 87, 14, 1.0),
                ),
                child: Center(
                  child: Text(
                    "Add Comment",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            if (comments.isNotEmpty)
              Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: comments
                      .map((comment) => Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(comment),
                    ),
                  ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
