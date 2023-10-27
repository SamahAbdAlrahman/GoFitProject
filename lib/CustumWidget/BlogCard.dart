import 'dart:io';

// import 'package:gofit_frontend/Model/addBlogModels.dart';
import 'package:gofit_frontend/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/addBlogModels.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({Key? key, required this.addBlogModel, required this.networkHandler})
      : super(key: key);

  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal:43, vertical: 10),
      width: MediaQuery.of(context).size.width,

      child: Card(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: networkHandler.getImage(addBlogModel.id ?? "",),
                    // fit: BoxFit.fill
                    fit: BoxFit.fill
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                height: 35,
                width: MediaQuery.of(context).size.width - 77,
                decoration: BoxDecoration(
                    color:     Color.fromRGBO(14, 14, 14, 0.5098039215686275),
                    borderRadius: BorderRadius.circular(0)),
                child: Text(
                  addBlogModel.title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
