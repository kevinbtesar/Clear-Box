import 'package:clearboxlending/helpers/base_stateful.dart';
import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:clearboxlending/screens/dashboard.dart';
import 'package:clearboxlending/screens/profile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  final String imageUrl =
      "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";
  final SharedPreferences preferences;

  MenuScreen(this.preferences);

  @override
  Widget build(BuildContext context) {
    String nameString = "";

    if (preferences.containsKey('first_name') &&
        preferences.getString('first_name') != "") {
      nameString =
          "Welcome, " + preferences.getString('first_name');
    } else {
      nameString = "ERROR - You're not logged in. Log out and log back in.";
    }

    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: true).toggle(false);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 62,
            left: 32,
            bottom: 8,
            right: MediaQuery.of(context).size.width / 2.9),
        color: Color(0xff454dff),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircularImage(
                    NetworkImage(imageUrl),
                  ),
                ),*/
                Text(
                  'Clear Box Lending\n',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  nameString,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Spacer(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              leading: Icon(
                Icons.dashboard,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Dashboard',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              leading: Icon(
                Icons.account_box,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Profile',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.monetization_on,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Get a Loan',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.library_books,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Walk Through',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            Spacer(),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.settings,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Settings',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.email,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Contact Support',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}
