import 'package:clearboxlending/helpers/base_stateful.dart';
import 'package:clearboxlending/navigation/menu_fragment.dart';
import 'package:clearboxlending/navigation/zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_dialog/tip_dialog.dart';

class LoanSetAmount extends StatefulWidget {
  @override
  LoanSetAmountState createState() => LoanSetAmountState();
}

class LoanSetAmountState extends BaseStatefulState<LoanSetAmount>
    with SingleTickerProviderStateMixin {
  MenuController menuController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences preferences;
  final FocusNode myFocusNode = FocusNode();

  double amount = 20;

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    preferences = BaseStatefulState.preferences;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NeumorphicTheme(
          themeMode: ThemeMode.light,
          theme: NeumorphicThemeData(
            lightSource: LightSource.topLeft,
            accentColor: NeumorphicColors.accent,
            depth: 4,
            intensity: 0.5,
          ),
          child: ChangeNotifierProvider(
            builder: (context) => menuController,
            child: ZoomScaffold(
              menuScreen: MenuScreen(preferences),
              contentScreen: Layout(
                  contentBuilder: (cc) => Scaffold(
                      key: _scaffoldKey,
                      body: new Container(
                        color: Colors.white,
                        child: new ListView(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new Container(
                                  height: 170.0,
                                  color: Colors.white,
                                  child: new Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Loan Amount",
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: NeumorphicSlider(
                                                style: SliderStyle(
                                                  accent: Colors.green,
                                                  variant: Colors.purple,
                                                ),
                                                value: amount,
                                                min: 5,
                                                max: 20,
                                                onChanged: (value) {
                                                  int intValue = value.round();
                                                  if (intValue < 10)
                                                    intValue = 5;
                                                  else if (intValue < 15)
                                                    intValue = 10;
                                                  else if (intValue < 20)
                                                    intValue = 15;
                                                  else
                                                    intValue = 20;
                                                  setState(() {
                                                    amount =
                                                        intValue.toDouble();
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "\$${amount.round()}",
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 44.0,
                                            child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Text(
                                                  "Take Out Loan",
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                                textColor: Colors.white,
                                                color: Color(0xFFf7d426),
                                                onPressed: () {
                                                  
                                                  TipDialogHelper.show(
                                                      tipDialog: new TipDialog(
                                                    type: TipDialogType.LOADING,
                                                    tip: "Loading",
                                                  ));
                                                  
                                                  payout();

                                                }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))),
              title: "Set Loan Amount",
            ),
          ),
        ),
        TipDialogContainer(
            duration: const Duration(seconds: 2),
            outsideTouchable: true,
            onOutsideTouch: (Widget tipDialog) {
              if (tipDialog is TipDialog &&
                  tipDialog.type == TipDialogType.LOADING) {
                TipDialogHelper.dismiss();
              }
            })
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
