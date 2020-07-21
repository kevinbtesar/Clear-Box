import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'login.dart';

class MainMenu extends StatefulWidget {
  //final VoidCallback signOut;
  final SharedPreferences _preferences = null;
  MainMenu(/*this.signOut*/ _preferences);

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  //SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  //signOut(BuildContext context) async {
  //signOut(BuildContext context) {
  signOut(SharedPreferences preferences) {
    //SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setBool("logged_in", false);
      preferences.setString("id", null);
      preferences.setString("email", null);
      preferences.setString("first_name", null);
      preferences.setString("last_name", null);
      preferences.setString("phone", null);
      preferences.setInt("user_status", 0);

      //widget.signOut();
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );*/
    });
    Navigator.pop(context);
  }

  int currentIndex = 0;
  String selectedIndex = 'TAB: 0';

  String email = "", first_name = "", last_name = "", id = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //setState(() {
    if (preferences.containsKey("logged_in")) {
      id = preferences.getString("id") ?? "";
      email = preferences.getString("email") ?? "";
      first_name = preferences.getString("first_name") ?? "";
      last_name = preferences.getString("last_name") ?? "";
    }
    //});
    print("id" + id);
    print("email" + email);
    print("first_name" + first_name);
    print("last_name" + last_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //signOut(context);
              signOut(widget._preferences);
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Welcome",
          style: TextStyle(fontSize: 30.0, color: Colors.blue),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.black,
        iconSize: 30.0,
//        iconSize: MediaQuery.of(context).size.height * .60,
        currentIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
          selectedIndex = 'TAB: $currentIndex';
//            print(selectedIndex);
          reds(selectedIndex);
        },

        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Color(0xFFf7d426)),
          BottomNavyBarItem(
              icon: Icon(Icons.view_list),
              title: Text('List'),
              activeColor: Color(0xFFf7d426)),
          BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              activeColor: Color(0xFFf7d426)),
        ],
      ),
    );
  }

  //  Action on Bottom Bar Press
  void reds(selectedIndex) {
//    print(selectedIndex);

    switch (selectedIndex) {
      case "TAB: 0":
        {
          callToast("Tab 0");
        }
        break;

      case "TAB: 1":
        {
          callToast("Tab 1");
        }
        break;

      case "TAB: 2":
        {
          callToast("Tab 2");
        }
        break;
    }
  }

  callToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
