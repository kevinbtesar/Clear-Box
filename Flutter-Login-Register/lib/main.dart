import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login/sharedloginregister.dart';

//void main() => runApp(Login());

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          //(X509Certificate cert, String host, int port) => true;
          ((X509Certificate cert, String host, int port) {
        final isValidHost =
            host == "clearboxlending.com" || host == "logogenie.net";
        return isValidHost;
      });
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();

  runApp(new MaterialApp(
    home: Login(),
  ));
}
