import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart' as Constants;
//
//
//
// LOGIN - BEGIN /////////////////////////////////////////////////////////////////////////////

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

//enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  //LoginStatus _loginStatus = LoginStatus.notSignIn;
  bool _loggedIn = false;
  bool _secureText = true;
  String email, password;
  final _key = new GlobalKey<FormState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(
        Constants.API_BASE_URL +
            Constants.API_VERIFICATION +
            "?" +
            Constants.API_URL_KEY +
            "=" +
            Constants.API_URL_VALUE,
        body: {
          "action_flag": 1.toString(),
          "email": email,
          "password": password,
          //"fcm_token": "test_fcm_token"
        });

    final data = jsonDecode(response.body);
    String apiStatus = data['api_status'];
    String apiMessage = data['api_message'];
    email = data['email'];
    String firstName = data['first_name'];
    String lastName = data['last_name'];
    String id = data['id'].toString();
    String phone = data['phone'];
    int userStatus = data['user_status'];

    if (apiStatus == 'success') {
      setState(() {
        //_loginStatus = LoginStatus.signIn;
        _loggedIn = true;

        savePref(/*1,*/ email, firstName, lastName, id);
      });
    } else {
      print("fail");
    }
    print(apiMessage);
    loginToast(apiMessage);
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  savePref(/*int value,*/ String email, String firstName, String lastName,
      String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //preferences.setInt("value", value);
      preferences.setBool("logged_in", _loggedIn);
      preferences.setString("first_name", firstName);
      preferences.setString("last_name", lastName);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  //var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //value = preferences.getInt("value");
      _loggedIn = preferences.getBool("logged_in");

      //_loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //preferences.setInt("value", null);
      preferences.setBool("logged_in", null);
      preferences.setString("first_name", null);
      preferences.setString("last_name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);

      preferences.commit();
      //_loginStatus = LoginStatus.notSignIn;
      _loggedIn = false;
    });

    loginToast(Constants.LOGOUT_SUCCESS);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    //switch (_loginStatus) {
    switch (_loggedIn) {
      //case LoginStatus.notSignIn:
      case false:
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
//            color: Colors.grey.withAlpha(20),
                    color: Colors.black,
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                              "http://scratchpads.eu/sites/all/themes/scratchpads_eu/images/sponsor-logo-ner.png"),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 50,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),

                          //card for Email TextFormField
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              validator: (e) {
                                if (e.isEmpty) {
                                  return Constants.EMAIL_ERROR_EMPTY;
                                }
                              },
                              onSaved: (e) => email = e,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 15),
                                    child:
                                        Icon(Icons.person, color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.all(18),
                                  labelText: "Email"),
                            ),
                          ),

                          // Card for password TextFormField
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              validator: (e) {
                                if (e.isEmpty) {
                                  return Constants.PASS_ERROR_EMPTY;
                                }
                              },
                              obscureText: _secureText,
                              onSaved: (e) => password = e,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.black),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                contentPadding: EdgeInsets.all(18),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          FlatButton(
                            onPressed: null,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(14.0),
                          ),

                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                height: 44.0,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    textColor: Colors.white,
                                    color: Color(0xFFf7d426),
                                    onPressed: () {
                                      check();
                                    }),
                              ),
                              SizedBox(
                                height: 44.0,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Text(
                                      Constants.GO_TO_REGISTER,
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    textColor: Colors.white,
                                    color: Color(0xFFf7d426),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;

      //case LoginStatus.signIn:
      case true:
        return MainMenu(signOut);
//        return ProfilePage(signOut);
        break;
    }
  }
}

// LOGIN - END /////////////////////////////////////////////////////////////////////////////////

// REGISTER - BEGIN /////////////////////////////////////////////////////////////////////////////

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String firstName, lastName, email, phone, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    final response = await http.post(
        Constants.API_BASE_URL +
            Constants.API_VERIFICATION +
            "?" +
            Constants.API_URL_KEY +
            "=" +
            Constants.API_URL_VALUE,
        body: {
          //.post(Constants.API_BASE_URL + Constants.API_VERIFICATION, body: {
          "action_flag": 2.toString(),
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "password": password,
          //"fcm_token": "test_fcm_token"
        });

    final data = jsonDecode(response.body);

    /**
     * Check value field for invalid registration. Anything besides 1 means unsuccessful.
     * Message field will contain success or fail message.
     */

    String apiMessage = data['api_message'];
    String apiStatus = data['api_status'];
    if (apiStatus != 'fail') {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      //print(message);
      //registerToast(message);
    }
    //print(message);
    registerToast(apiMessage);
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                          "https://www.logogenie.net/download/preview/medium/3589659"),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      //card for First Name TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert a first name";
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
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "First Name"),
                        ),
                      ),

                      //card for Last Name TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert a last name";
                            }
                          },
                          onSaved: (e) => lastName = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Last Name"),
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert an email";
                            }
                          },
                          onSaved: (e) => email = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Email"),
                        ),
                      ),

                      //card for Mobile TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please insert a phone number";
                            }
                          },
                          onSaved: (e) => phone = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phone, color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Phone Number",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      //card for Password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Password"),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color(0xFFf7d426),
                                onPressed: () {
                                  check();
                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Go to Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color(0xFFf7d426),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// REGISTER - END /////////////////////////////////////////////////////////////////////////////////

// MainMenu - BEGIN /////////////////////////////////////////////////////////////////////////////

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  int currentIndex = 0;
  String selectedIndex = 'TAB: 0';

  String email = "", first_name = "", last_name = "", id = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      first_name = preferences.getString("first_name");
      last_name = preferences.getString("last_name");
    });
    print("id" + id);
    print("email" + email);
    print("first_name" + first_name);
    print("last_name" + last_name);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
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
