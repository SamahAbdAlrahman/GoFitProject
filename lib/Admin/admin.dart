import 'package:flutter/material.dart';
import 'package:gofit_frontend/Admin/new_coach.dart';
import 'edit pages.dart';
import 'newNutritionist.dart';

void main() => runApp(MaterialApp(
  home: DrawerDemo(),
));

class DrawerDemo extends StatefulWidget {
  const DrawerDemo({Key? key});

  @override
  _DrawerDemoState createState() => _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> {
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(248, 96, 2, 1.0),
                    Color.fromRGBO(190, 57, 33, 1.0)
                  ],
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/img/u1.png'), // استبدل بمسار صورتك
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.table_rows),
              title: Text('Tables'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Gym information'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Statics'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.messenger),
              title: Text('Chat'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit pages'),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => pages()));
              },
            ),
            // Add more ListTile widgets for additional menu items
            ListTile(
              leading: Icon(Icons.add_circle_outlined),
              title: Text('Add Coach'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewCoach()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outlined),
              title: Text('Add Nutritionist'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => newNutritionist()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: media.width * 0.25,
                collapsedHeight: kToolbarHeight + 20,
                flexibleSpace: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(248, 96, 2, 1.0),
                            Color.fromRGBO(190, 57, 33, 1.0)
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Home page",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'LibreBaskerville',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
