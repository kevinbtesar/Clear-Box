import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context, String text, String label) {
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: label,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  // Find the Scaffold in the widget tree and use it to show a SnackBar.
  return Scaffold.of(context).showSnackBar(snackBar);
}
