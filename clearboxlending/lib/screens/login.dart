import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

import 'package:clearboxlending/helpers/constants.dart' as Constants;
import 'package:clearboxlending/screens/register.dart';
import 'package:clearboxlending/screens/dashboard.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _loggedIn = false;
  bool _secureText = true;
  String _email, _password;
  SharedPreferences _preferences;
  StreamSubscription _linkStreamSubscription;
  String _latestLink;
  Uri _latestUri;
  String _initialLink;
  Uri _initialUri;

  final _key = new GlobalKey<FormState>();
  final _globalKey = new GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getPref(); // Call getPref() method
    initUniLinks();
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
    _linkStreamSubscription.cancel();
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
                          height: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            login("paypal");
                          },
                          child: Image.asset(
                            'assets/images/connectwithpaypalbutton.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Text(
                            "Or Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                            _launchURL(Constants.LOST_PASSWORD);
                          },
                          child: Text(
                            "Create or Forgot Password",
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
      return new Dashboard(/*signOut*/ _preferences);
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
      login("manual");
    }
  }

  login(String type) async {
    String apiStatus = "fail";
    String apiMessage = "No response found";

    http.Response response;
    if (type == "manual") {
      response = await http.post(
          Constants.API_BASE_URL +
              Constants.API_MAIN +
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
    } else {
      response = await http.post(
          Constants.API_BASE_URL +
              "paypal/" +
              Constants.API_PAYPAL +
              "?" +
              Constants.API_URL_KEY +
              "=" +
              Constants.API_URL_VALUE,
          body: {});
    }

    // PHP ERRORS?
    // Step 1. Comment out ob_get_clean() in api_main.php to see body of errors.
    // Step 2. Add break to `jsonDecode(response.body);`
    // Step 3. in Debug List of variables, find outer body variable. Right click, and copy value.
    if (response.body != null && response.body.isNotEmpty) {
      final data =
          jsonDecode(response.body); // <- break here to see body of PHP errors
      if (data['redirect_url'] != null) {
        apiStatus = data['api_status'];
        apiMessage = data['api_message'];

        String url = data['redirect_url'];
        _launchURL(url);
      } else {
        _email = data['email'];
        String firstName = data['first_name'];
        String lastName = data['last_name'];
        String id = data['id'].toString();
        String phone = data['phone'];
        String userStatus = data['user_status'];
        if (apiStatus == 'success') {
          setState(() {
            _loggedIn = true;
            savePref(_email, firstName, lastName, id);
          });
        } else {
          print("fail");
        }
      }
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// An implementation using a [String] link
  Future<void> initUniLinks() async {
    // Attach a listener to the links stream
    _linkStreamSubscription = getLinksStream().listen((String link) {
      if (!mounted) return;
      print('got link: $link');
      closeWebView();
      /*setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });*/
    }, onError: (Object err) {
      if (!mounted) return;
      print('got err: $err');
      /*setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });*/
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      print('initial link: $_initialLink');
      await closeWebView();
      //if (_initialLink != null) _initialUri = Uri.parse(_initialLink);
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      //_initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      //_initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    /*if (!mounted) return;

    setState(() {
      _latestLink = _initialLink;
      _latestUri = _initialUri;
    });*/
  }
}
