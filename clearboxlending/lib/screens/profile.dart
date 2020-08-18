import 'dart:ui';

import 'package:clearboxlending/navigation/menu_fragment.dart';
import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:clearboxlending/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final SharedPreferences preferences;
  Profile(this.preferences);

  @override
  ProfileState createState() => ProfileState(preferences);
}

class ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  MenuController menuController;

  //static final List<String> chartDropdownItems = ['All', 'Personal', 'Off'];
  String actualDropdown = stateDropdownItems[0];
  int actualChart = 0;

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  ProfileState(SharedPreferences preferences);

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    String firstName, lastName, email, phone, password;

    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(widget.preferences),
        contentScreen: Layout(
            contentBuilder: (cc) => Scaffold(
                    body: new Container(
                  color: Colors.white,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            height: 200.0,
                            color: Colors.white,
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: new Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                                width: 140.0,
                                                height: 140.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    image: new ExactAssetImage(
                                                        'assets/images/as.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 90.0, right: 100.0),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                new CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 25.0,
                                                  child: new Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            )),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          new Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Personal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : new Container(),
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Card(
                                      elevation: 6.0,
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert your first name";
                                          }
                                        },
                                        onSaved: (e) => firstName = e,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(Icons.person,
                                                  color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.all(18),
                                            labelText: "First Name"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Card(
                                      elevation: 6.0,
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert your last name";
                                          }
                                        },
                                        onSaved: (e) => firstName = e,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(Icons.person,
                                                  color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.all(18),
                                            labelText: "Last Name"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Email',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Card(
                                      elevation: 6.0,
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert your email address";
                                          }
                                        },
                                        onSaved: (e) => firstName = e,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(Icons.alternate_email,
                                                  color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.all(18),
                                            labelText: "Email Address"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Phone',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Card(
                                      elevation: 6.0,
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert your email address";
                                          }
                                        },
                                        onSaved: (e) => firstName = e,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(Icons.phone,
                                                  color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.all(18),
                                            labelText: "Phone Number"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Address',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Card(
                                      elevation: 6.0,
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert your email address";
                                          }
                                        },
                                        onSaved: (e) => firstName = e,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(Icons.mail,
                                                  color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.all(18),
                                            labelText: "Address"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 0.0),
                                      child: new Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: new Card(
                                                elevation: 6.0,
                                                child: DropdownButtonFormField(
                                                    isExpanded: true,
                                                    decoration: InputDecoration(
                                                        prefixIcon: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Icon(
                                                              Icons.mail,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.all(16),
                                                        labelText: "State"),
                                                    isDense: true,
                                                    value: actualDropdown,
                                                    onChanged: (String value) =>
                                                        setState(() {
                                                          actualDropdown =
                                                              value;
                                                          actualChart =
                                                              stateDropdownItems
                                                                  .indexOf(
                                                                      value); // Refresh the chart
                                                        }),
                                                    items: stateDropdownItems
                                                        .map((String title) {
                                                      return DropdownMenuItem(
                                                        value: title,
                                                        child: Text(title,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14.0),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible),
                                                      );
                                                    }).toList())),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: new Card(
                                              elevation: 6.0,
                                              child: TextFormField(
                                                validator: (e) {
                                                  if (e.isEmpty) {
                                                    return "Please insert your zip code";
                                                  }
                                                },
                                                onSaved: (e) => firstName = e,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                decoration: InputDecoration(
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 15),
                                                      child: Icon(Icons.mail,
                                                          color: Colors.black),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(18),
                                                    labelText: "Zip Code"),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))),
        preferences: widget.preferences,
        title: "Profile",
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
