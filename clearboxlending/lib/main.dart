import 'dart:io';

import 'package:flutter/material.dart';

import 'screens/login.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        final isValidHost = host == "clearboxlending.com" ||
            host == "logogenie.net" ||
            host == "google.com" ||
            host == "stackpath.bootstrapcdn.com";
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