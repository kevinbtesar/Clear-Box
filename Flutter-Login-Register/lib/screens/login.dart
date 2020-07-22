import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart' as Constants;
import 'register.dart';
import 'main_menu.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _loggedIn = false;
  bool _secureText = true;
  String _email, _password;
  SharedPreferences _preferences;

  final _key = new GlobalKey<FormState>();
  final _globalKey = new GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getPref(); // Call getPref() method
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _globalKey,
      body: _login(),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  Widget _login() {
    if (_loggedIn == null || _loggedIn == false) {
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
                  color: Colors.grey.withAlpha(20),
//                  color: Colors.black,
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),

                        //card for Email TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            controller: emailController,
                            validator: (e) {
                              if (e.isEmpty) {
                                return Constants.EMAIL_ERROR_EMPTY;
                              }
                            },
                            onSaved: (e) => _email = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
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
                            onSaved: (e) => _password = e,
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
                          onPressed: () {
                            resetPassword();
                          },
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
    } else {
      return new MainMenu(/*signOut*/ _preferences);
      //return ProfilePage(signOut);
    }
  }

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
          "email": _email,
          "password": _password,
          //"fcm_token": "test_fcm_token"
        });

    final data = jsonDecode(response.body);
    String apiStatus = data['api_status'];
    String apiMessage = data['api_message'];
    _email = data['email'];
    String firstName = data['first_name'];
    String lastName = data['last_name'];
    String id = data['id'].toString();
    String phone = data['phone'];
    int userStatus = data['user_status'];

    if (apiStatus == 'success') {
      setState(() {
        _loggedIn = true;

        savePref(_email, firstName, lastName, id);
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

  savePref(String email, String firstName, String lastName, String id) async {
    setState(() {
      _preferences.setBool("logged_in", _loggedIn);
      _preferences.setString("first_name", firstName);
      _preferences.setString("last_name", lastName);
      _preferences.setString("email", email);
      _preferences.setString("id", id);
    });
  }

  getPref() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _loggedIn = _preferences.getBool("logged_in") ?? false;
    });
  }

  resetPassword() async {
    int apiStatus = 500;
    String apiMessage = '';

    if (emailController.text != null) {
      _email = emailController.text;
      final response = await http.post(Constants.EMAIL_RESET_API_URL, body: {
        //"action_flag": 1.toString(),
        "email": _email,
      });

      final data = jsonDecode(response.body);
      apiStatus = data['data']['status'] ?? 500;
      apiMessage = data['message'] ??
          "If email address was found, an email containing your reset link will be sent to it.";
      //String firstName = data['first_name'];

    } else {
      apiMessage = 'Email cannot be empty';
    }

    if (apiStatus != 200) {
      apiMessage = "Network connection not found";
    }
    print(apiMessage);
    loginToast(apiMessage);
  }
}
