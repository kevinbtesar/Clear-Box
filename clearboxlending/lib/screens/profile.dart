import 'dart:ui';

import 'package:clearboxlending/helpers/base_stateful.dart';
import 'package:clearboxlending/navigation/menu_fragment.dart';
import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:clearboxlending/helpers/constants.dart';
import 'package:clearboxlending/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'dart:convert';

import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends BaseStatefulState<Profile>
    with SingleTickerProviderStateMixin {

  MenuController menuController;
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String actualDropdown = stateDropdownItems[0];
  int actualChart = 0;
  SharedPreferences preferences;
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    preferences = BaseStatefulState.preferences;
  }

  @override
  Widget build(BuildContext context) {
    String firstName, lastName, email, phone, password;

    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(preferences),
        contentScreen: Layout(
            contentBuilder: (cc) => Scaffold(
                key: _scaffoldKey,
                body: new Container(
                  color: Colors.white,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            height: 170.0,
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
                                                        'assets/images/avatar2.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 90.0, right: 85.0),
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
                                          return "";
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
                                          return "";
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
                                              Text(
                                                'Email - IMPORTANT:\nUse same email as PayPal ID/Email',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                              
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
                                          return "";
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
                                          return "";
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
                                            return "Please insert your street address";
                                          }
                                          return "";
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
                                            labelText: "Street Address"),
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
                                            return "Please insert your city";
                                          }
                                          return "";
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
                                            labelText: "City"),
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
                                                                  left: 20,
                                                                  right: 15),
                                                          child: Icon(
                                                              Icons.mail,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                6, 10, 6, 20),
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
                                                    return "Insert your zip code";
                                                  }
                                                  return "";
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
                                                'Upload Documents',
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
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Image.asset(
                                                'assets/images/checked-empty.png'),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 4, right: 2)),
                                            Container(
                                              width: 150,
                                              child: Text(
                                                'Driver\'s License or State ID',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 32.0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      getImageCamera(
                                                          "id_doc", 0);
                                                    },
                                                    icon: Icon(
                                                      Icons.image,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    getImageCamera("id_doc", 0);
                                                  },
                                                  child: Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15)),
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 32.0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      getImageCamera(
                                                          "id_doc", 1);
                                                    },
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    getImageCamera("id_doc", 1);
                                                  },
                                                  child: Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Card(
                                      elevation: 6.0,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Image.asset(
                                                'assets/images/checked-empty.png'),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6)),
                                            Container(
                                              width: 150,
                                              child: Text(
                                                'Paystub - Not older than a month',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 32.0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      getImageCamera(
                                                          "paystub", 0);
                                                    },
                                                    icon: Icon(
                                                      Icons.image,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    getImageCamera(
                                                        "paystub", 0);
                                                  },
                                                  child: Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15)),
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 32.0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      getImageCamera(
                                                          "paystub", 1);
                                                    },
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    getImageCamera(
                                                        "paystub", 1);
                                                  },
                                                  child: Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                                                'PayPal',
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
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Image.asset(
                                                'assets/images/checked-empty.png'),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8)),
                                            Container(
                                              width: 150,
                                              child: Text(
                                                'Link your PayPal account',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: Image.asset(
                                                  'assets/images/PayPal.png'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))),
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

  Future getImageCamera(String metaKey, int source) async {
    var responseMessage = "";
    var imageFile;
    // 0 - gallery
    // 1 - camera
    if (source == 0)
      imageFile = await picker.getImage(source: ImageSource.gallery);
    else if (source == 1)
      imageFile = await picker.getImage(source: ImageSource.camera);

    if (imageFile != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;

      int rand = new Math.Random().nextInt(100000);
      Img.Image image =
          Img.decodeImage(Io.File(imageFile.path).readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 500);

      var name = "$path/image_$rand.jpg";
      var compressImg = new Io.File(name)
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      final uri = Uri.parse(
          API_BASE_URL + API_MAIN + "?" + API_URL_KEY + "=" + API_URL_VALUE);
      var request = http.MultipartRequest('POST', uri);
      request.fields['action_flag'] = "3";
      request.fields['user_id'] = BaseStatefulState.userId;
      request.fields['meta_key'] = metaKey;
      //request.fields['name'] = name;

      // gotten from https://stackoverflow.com/questions/49125191/how-to-upload-images-and-file-to-a-server-in-flutter
      var pic = await http.MultipartFile.fromPath("image", compressImg.path);
      request.files.add(pic);

      await request.send().then((response) async {
        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          print("value: " + value);
          responseMessage = "Success! value: " + value;
        });

        if (response.statusCode == 200) {
          responseMessage = responseMessage + ' - Image Uploaded';
        } else {
          responseMessage = responseMessage +
              'Image Not Uploaded. Status code: ' +
              response.statusCode.toString();
        }
      }).catchError((error) {
        print("error: " + error);
        responseMessage = "Error! error: " + error;
      });

      //String apiMessage = data['api_message'];
      //String apiStatus = data['api_status'];
      getSnackBar(_scaffoldKey, responseMessage);
    }
  }
}
