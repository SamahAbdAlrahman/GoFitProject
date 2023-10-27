import 'package:gofit_frontend/common/colo_extension.dart';
import 'package:gofit_frontend/common_widget/tab_button1.dart';
import 'package:gofit_frontend/screens/main_tab/select_view.dart';
import 'package:flutter/material.dart';

import 'package:gofit_frontend/screens/login/signup_screen.dart';
import 'package:gofit_frontend/screens/login/login_screen.dart';
import '../workout_tracker/workout_tracker_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();

  Widget currentTab = SelectView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColor.primaryG,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,)
                ]),
            child: Icon(Icons.search,color: TColor.white, size: 35, ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(color: TColor.white, boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
            ]),
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                    icon: "assets/img/home_tab.png",
                    selectIcon: "assets/img/home_tab.png",
                    isActive: selectTab == 0,
                    onTap: () {
                      selectTab = 0;
                      currentTab =  SelectView();
                      if (mounted) {
                        setState(() {});
                      }
                    }),



                const  SizedBox(width: 40,),



                TabButton(
                  icon: "assets/img/profile_tab.png",
                  selectIcon: "assets/img/profile_tab_select.png",
                  isActive: selectTab == 3,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(""),
                          content: Text("Do you have an account ?", style: TextStyle(
                            color:  Colors.black54,
                          ),),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color:  Colors.black45,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                            ),
                            TextButton(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  color:   Colors.black45,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NewAccountScreen()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

          )),
    );
  }
}