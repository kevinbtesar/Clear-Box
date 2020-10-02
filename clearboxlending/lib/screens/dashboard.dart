import 'package:clearboxlending/helpers/base_stateful.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:clearboxlending/navigation/menu_fragment.dart';
import 'package:clearboxlending/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  //final VoidCallback signOut;

  Dashboard(/*this.signOut this._preferences*/);

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends BaseStatefulState<Dashboard>
    with SingleTickerProviderStateMixin {
  MenuController menuController;
  bool initFlag = false;
  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    if (!initFlag) {
      initFlag = true;
      menuController = new MenuController(
        vsync: this,
      )..addListener(() => setState(() {}));

      // ignore: unnecessary_statements
      () => checkLoggedIn();
      preferences = BaseStatefulState.preferences;
    }
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

  String email = "", firstName = "", lastName = "", id = "";
  TabController tabController;

  final List<List<double>> charts = [
    [2.9, 2.8, 3.4],
    [
      0.0,
      0.3,
    ]
  ];

  static final List<String> chartDropdownItems = ['All', 'Personal', 'Off'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
          menuScreen: MenuScreen(preferences),
          contentScreen: Layout(
            contentBuilder: (cc) => Scaffold(
                body: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Loans\navailable',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text('40',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Est days until\nnext available loan',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text('6',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0))
                            ],
                          ),
                          Material(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline,
                                    color: Colors.white, size: 30.0),
                              )))
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                              color: Colors.teal,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.settings_applications,
                                    color: Colors.white, size: 30.0),
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text('Borrow \$20',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23.0)),
                          Text('Get a \$20 for 1 week.',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 12.0)),
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                              color: Colors.amber,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.notifications,
                                    color: Colors.white, size: 30.0),
                              )),
                          Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          Text('Alerts',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.0)),
                          DropdownButton(
                              isDense: true,
                              value: actualDropdown,
                              onChanged: (String value) => setState(() {
                                    actualDropdown = value;
                                    actualChart = chartDropdownItems
                                        .indexOf(value); // Refresh the chart
                                  }),
                              items: chartDropdownItems.map((String title) {
                                return DropdownMenuItem(
                                  value: title,
                                  child: Text(title,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0)),
                                );
                              }).toList())
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Help!',
                                  style: TextStyle(color: Colors.redAccent)),
                              Text('How does it work?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0))
                            ],
                          ),
                          Material(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.store,
                                    color: Colors.white, size: 30.0),
                              )))
                        ]),
                  ),
                  onTap: () => {},
                ),
                Builder(
                    builder: (context) => Center(
                            child: RaisedButton(
                          onPressed: () {
                            showSnackBar(context,
                                "Yay! It\'s Kevin\'s SnackBar!", "My Undo");
                          },
                          child: Text('Show Kevin\'s SnackBar'),
                        ))),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 110.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 110.0),
              ],
            )),
          ),
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
