//import 'package:clearboxlending/navigation/circular_image.dart';
import 'package:clearboxlending/navigation/zoom_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  final SharedPreferences preferences;
  final String imageUrl =
      "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";

  final List<MenuItem> options = [
    MenuItem(Icons.dashboard, 'Dashboard'),
    MenuItem(Icons.account_box, 'Profile'),
    MenuItem(Icons.monetization_on, 'Get a Loan'),
    MenuItem(Icons.library_books, 'Walk-Through'),
  ];

  MenuScreen({this.preferences});

  @override
  Widget build(BuildContext context) {
    String nameString = "";

    if (preferences.containsKey('first_name') &&
        preferences.getString('first_name') != "") {
      nameString = "Welcome, " + preferences.getString('first_name');
    } else {
      nameString = "You're not logged in";
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
            Column(
              children: options.map((item) {
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                );
              }).toList(),
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
