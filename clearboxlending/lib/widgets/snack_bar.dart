import 'package:flutter/material.dart';

//
// both showSnackBar and getSnackBar are from
// https://stackoverflow.com/questions/40579879/display-snackbar-in-flutter
//

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

////// snack bar V2 ///////////

getSnackBar(GlobalKey<ScaffoldState> scaffoldKey, text) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
}
