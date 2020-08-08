import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:clearboxlending/navigation/menu_fragment.dart';
import 'package:clearboxlending/widgets/snack_bar.dart';

class Dashboard extends StatefulWidget {
  //final VoidCallback signOut;
  final SharedPreferences _preferences;
  Dashboard(/*this.signOut*/ this._preferences);

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<Dashboard>
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
    /**
     * Commented out due to causing an error. 
     * This method included is how main.dart came from flutter_delivery-master
     */
    //menuController.dispose();
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
          menuScreen: MenuScreen(preferences: this.getPref()),
          contentScreen: Layout(
            contentBuilder: (cc) => Scaffold(
                body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ),
                    RaisedButton(
                      onPressed: () {
                        showSnackBar(context, "Yay! It\'s Kevin\'s SnackBar!",
                            "My Undo");
                      },
                      child: Text('Show Kevin\'s SnackBar'),
                    ),
                  ]),
            )),
          ),
          preferences: this.getPref(),
          title: "Dashboard"),
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
