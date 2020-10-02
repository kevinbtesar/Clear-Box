import 'package:clearboxlending/helpers/base_stateful.dart';
import 'package:flutter/material.dart';

import 'package:clearboxlending/screens/register.dart';
import 'package:clearboxlending/helpers/constants.dart' as Constants;
import 'package:tip_dialog/tip_dialog.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends BaseStatefulState<Login> {
  bool _secureText = true;
  bool initFlag = false;

  final _key = new GlobalKey<FormState>();
  final _globalKey = new GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _globalKey,
          body: _login(),
        ),
        TipDialogContainer(
          duration: const Duration(seconds: 2),
          outsideTouchable: true,
          onOutsideTouch: (Widget tipDialog) {
            if (tipDialog is TipDialog &&
                tipDialog.type == TipDialogType.LOADING) {
              TipDialogHelper.dismiss();
            }
          }
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();

    if (!initFlag) {
      initFlag = true;
      // ignore: unnecessary_statements
      () => checkLoggedIn();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
  }

  Widget _login() {
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
                      //Image.network(
                      //    "http://scratchpads.eu/sites/all/themes/scratchpads_eu/images/sponsor-logo-ner.png"),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () {
                          login("paypal");

                          TipDialogHelper.show(
                              tipDialog: new TipDialog(
                            type: TipDialogType.LOADING,
                            tip: "Loading",
                          ));
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
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
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
                          onSaved: (e) => BaseStatefulState.email = e,
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
                          onSaved: (e) => BaseStatefulState.password = e,
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
                          BaseStatefulState.launchURL(Constants.LOST_PASSWORD);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color(0xFFf7d426),
                                onPressed: () {
                                  
                                  check();

                                  TipDialogHelper.show(
                                    tipDialog: new TipDialog(
                                      type: TipDialogType.LOADING,
                                      tip: "Loading",
                                  ));

                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  Constants.GO_TO_REGISTER,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color(0xFFf7d426),
                                onPressed: () {
                                  Navigator.push(
                                    this.context,
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
}
