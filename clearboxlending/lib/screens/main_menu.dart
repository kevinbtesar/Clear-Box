import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:clearboxlending/navigation/menu_page.dart';

class MainMenu extends StatefulWidget {
  //final VoidCallback signOut;
  final SharedPreferences _preferences;
  MainMenu(/*this.signOut*/ this._preferences);

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  MenuController menuController;

  @override
  void initState() {
    super.initState();
    getPref();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  int currentIndex = 0;
  String selectedIndex = 'TAB: 0';

  String email = "", first_name = "", last_name = "", id = "";
  TabController tabController;

  SharedPreferences getPref() {
    SharedPreferences preferences = widget._preferences;
    setState(() {
      if (preferences.containsKey("logged_in")) {
        id = preferences.getString("id") ?? "";
        email = preferences.getString("email") ?? "";
        first_name = preferences.getString("first_name") ?? "";
        last_name = preferences.getString("last_name") ?? "";

        print("id" + id);
        print("email" + email);
        print("first_name" + first_name);
        print("last_name" + last_name);
      }
    });
    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(),
        contentScreen: Layout(
            contentBuilder: (cc) => Scaffold(
                  /*appBar: AppBar(
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          //signOut(context);
                          signOut(widget._preferences);
                        },
                        icon: Icon(Icons.lock_open),
                      )
                    ],
                    title: Text(""),
                    automaticallyImplyLeading: false,
                  ),*/
                  body: Center(
                    child: Text(
                      "Welcome",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ),
                  ),
                )),
        preferences: this.getPref(),
      ),
    );

    //
    /*return Scaffold(
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
        title: Text(""),
        automaticallyImplyLeading: false,
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
    );*/
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
