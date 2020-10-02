import 'package:flutter/widgets.dart';

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  static bool loggedIn;

  BaseStatefulState() {
    // Parent constructor
  }

  void baseMethod() {
    // Parent method
  }
}
