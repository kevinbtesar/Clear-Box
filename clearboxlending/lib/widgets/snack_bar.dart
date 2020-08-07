import 'package:flutter/material.dart';

BuildContext context;

// Find the Scaffold in the widget tree and use it to show a SnackBar.
final mSnackbar = Scaffold.of(context).showSnackBar(snackBar);

final snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
      // Some code to undo the change.
    },
  ),
);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> getSnackBar() {
  return mSnackbar;
}
