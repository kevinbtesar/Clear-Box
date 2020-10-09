import 'dart:async';
import 'dart:convert';

import 'package:clearboxlending/screens/dashboard.dart';
import 'package:clearboxlending/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:clearboxlending/helpers/constants.dart' as Constants;

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  static StreamSubscription _linkStreamSubscription;
  static SharedPreferences preferences;
  static String userId,
      email,
      password,
      firstName,
      lastName,
      phone,
      userStatus,
      streetAddress,
      locality,
      region,
      postalCode,
      country,
      paypalEmailVerified,
      paypalPayerId,
      verifiedPaypalAccount;
  static bool loggedIn;
  static bool usedUniLinkFlag = false;
  static bool initFlag = false;

  @override
  void initState() {
    super.initState();
    if (!initFlag) {
      initFlag = true;

      setSharedPreferences();

      // Attach a listener to the links stream
      _linkStreamSubscription = getLinksStream().listen((String link) {
        print('GOT link: $link');
      }, onError: (Object err) {
        print('GOT err: $err');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_linkStreamSubscription != null) _linkStreamSubscription.cancel();
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*
   * LOGIN LOGIC 
   *
   */
  login(String type) async {
    String apiStatus = "fail";
    String apiMessage = "No response found";

    http.Response response;

    /**
     * MANUAL LOGIN - START
     */

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
            "email": email,
            "password": password,
            //"fcm_token": "test_fcm_token"
          });
    } else {
      /**
       * PAYPAL ACCESS TOKEN LOGIN - START
       */

      String accessToken = "";
      int accessCodeExpiration;
      SharedPreferences preferences = await SharedPreferences.getInstance();

      if (preferences.containsKey("access_token_expiration")) {
        accessCodeExpiration = preferences.getInt("access_token_expiration");

        var difference = accessCodeExpiration -
            new DateTime.now().toUtc().millisecondsSinceEpoch;
        // 28800000=8 hours in milliseconds
        if (difference > 0) {
          if (preferences.containsKey("access_token") &&
              preferences.getString("access_token") != "fail") {
            // Comment out the following line if testing deep linking is needed
            accessToken = preferences.getString("access_token");
          }
        }
      }

      response = await http.post(
          Constants.API_BASE_URL +
              "paypal/" +
              Constants.API_PAYPAL +
              "?" +
              Constants.API_URL_KEY +
              "=" +
              Constants.API_URL_VALUE,
          body: {"access_token": accessToken});
    }
    /**
     * PAYPAL ACCESS TOKEN LOGIN - END
     *
     */

    // PHP ERRORS?
    // Step 1. Comment out ob_get_clean() in api_main.php to see body of errors.
    // Step 2. Add break to `jsonDecode(response.body);`
    // Step 3. in Debug List of variables, find outer body variable. Right click, and copy value.

    if (response.body != null && response.body.isNotEmpty) {
      final data =
          jsonDecode(response.body); // <- break here to see body of PHP errors

      apiStatus = data['api_status'];
      apiMessage = data['api_message'];

      /**
       * Redirect gotten back from Custom PayPal API **********
       */
      if (data['redirect_url'] != null && data['redirect_url'] != "") {
        launchURL(data['redirect_url']);
      } else {
        /**
         * User Info gotten back from Custom PayPal API **********
         */
        Map<String, dynamic> userInfo = jsonDecode(data['user_info']);

        // userId, email, password, firstName, lastName, phone, userStatus, streetAddress, locality,
        // region, postalCode, country, paypalEmailVerified, paypalPayerId, verifiedPaypalAccount;

        email = userInfo['email'];
        List<String> nameArray = userInfo['name'].split(" ");
        firstName = nameArray[0];
        preferences.setString('first_name', firstName);
        lastName = nameArray[1];
        userId = userInfo['ID'];
        phone = userInfo['phone'];
        userStatus = userInfo['user_status'];
        streetAddress = userInfo['street_address'];
        locality = userInfo['locality'];
        region = userInfo['region'];
        postalCode = userInfo['postal_code'];
        country = userInfo['country'];
        paypalEmailVerified = userInfo['paypal_email_verified'];
        paypalPayerId = userInfo['paypal_payer_id'];
        verifiedPaypalAccount = userInfo['verified_paypal_account'];

        //print(firstName + " " + preferences.getString("first_name"));

        if (apiStatus == 'success') {
          loggedIn = true;
          checkLoggedIn();
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

/*
 * PAYOUT LOGIC - BEGIN
 *
 */

  payout(double amount) async {
    String apiStatus = "fail";
    String apiMessage = "No response found";
    print("userId: " + userId + " email: " + email);

    http.Response response;
    response = await http.post(
        Constants.API_BASE_URL +
            "paypal/" +
            Constants.API_PAYPAL_PAYOUT +
            "?" +
            Constants.API_URL_KEY +
            "=" +
            Constants.API_URL_VALUE,
        body: {
          "amount": amount.toInt().toString(),
          "email": email,
          "user_id": userId,
          //"fcm_token": "test_fcm_token"
        });

    if (response.body != null && response.body.isNotEmpty) {
      final data =
          jsonDecode(response.body); // <- break here to see body of PHP errors

      apiStatus = data['api_status'];
      apiMessage = data['api_message'];

      if (apiStatus == 'success') {
        print("success");
      } else {
        print("fail");
      }
    }

    TipDialogHelper.dismiss();
    print(apiMessage);
    loginToast(apiMessage);
  }

/*
 * PAYOUT LOGIC - END
 *
 */

  setSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

// userId, email, password, firstName, lastName, phone, userStatus, streetAddress, locality,
// region, postalCode, country, paypalEmailVerified, paypalPayerId, verifiedPaypalAccount;
  signOut() {
    userId = null;
    email = null;
    firstName = null;
    lastName = null;
    password = null;
    phone = null;
    userStatus = null;
    streetAddress = null;
    locality = null;
    region = null;
    postalCode = null;
    country = null;
    paypalEmailVerified = null;
    paypalPayerId = null;
    verifiedPaypalAccount = null;

    preferences.setString("access_token", "");
    preferences.setInt("access_token_expiration", 0);

    loggedIn = null;
    checkLoggedIn();
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

  /// An implementation using a [String] link
  initUniLinks() async {
    String initialLink;

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();

      if (initialLink != null && !usedUniLinkFlag) {
        usedUniLinkFlag = true;
        await closeWebView();
        String accessToken = "";
        print('initial link: ' + initialLink);
        Uri uri = Uri.dataFromString(initialLink);
        Map<String, String> uriObj = uri.queryParameters;
        uriObj.forEach((k, v) {
          //print(k);
          //print(v);
          // userId, email, password, firstName, lastName, phone, userStatus, streetAddress, locality,
          // region, postalCode, country, paypalEmailVerified, paypalPayerId, verifiedPaypalAccount;
          if (k == 'access_token')
            accessToken = v;
          else if (k == 'email')
            email = v;
          else if (k == 'first_name')
            firstName = v;
          else if (k == 'last_name')
            lastName = v;
          else if (k == 'user_id')
            userId = v;
          else if (k == 'phone')
            phone = v;
          else if (k == 'user_status')
            userStatus = v;
          else if (k == 'street_address')
            streetAddress = v;
          else if (k == 'locality')
            locality = v;
          else if (k == 'region')
            region = v;
          else if (k == 'country')
            country = v;
          else if (k == 'paypal_email_verified')
            paypalEmailVerified = v;
          else if (k == 'paypal_payer_id')
            paypalPayerId = v;
          else if (k == 'verified_paypal_account') verifiedPaypalAccount = v;
        });

        if (accessToken != null &&
            accessToken != "" &&
            userId != null &&
            userId != "") {
          var now = new DateTime.now().toUtc();
          var eightHoursFromNow = now.add(new Duration(hours: 8));
          preferences.setString("access_token", accessToken);
          preferences.setInt("access_token_expiration",
              eightHoursFromNow.millisecondsSinceEpoch);

          loggedIn = true;
        } else {
          // There was an issue getting either the access token or the user ID from deep linking

          loggedIn = false;
          print('fail');
        }

        checkLoggedIn();
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      print('fail');
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      print('fail');
    }
  }

  checkLoggedIn() {
    if (loggedIn == null || loggedIn == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (Route<dynamic> route) => false);

      /* Old method of navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );*/
    }
  }

  /*
  
  preferences.setString("id", null);
  preferences.setString("email", null);
  preferences.setString("first_name", null);
  preferences.setString("last_name", null);
  preferences.setString("phone", null);
  preferences.setInt("user_status", 0);
  TODO - preferences.setInt("user_address", 0);

  
  savePref(
    String email, String firstName, String lastName /*, String id*/) async {
    
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;
    else {
      //setState(() {
        preferences.setString("first_name", firstName);
        preferences.setString("last_name", lastName);
        preferences.setString("email", email);
      //});
    }
  }*/
}
