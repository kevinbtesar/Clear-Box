package com.clearboxlending.flutter_login;



public class FlutterNativeWebPlugin {

    public static void registerWith(Registrar registrar) {
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "ponnamkarthik/flutterwebview", new FlutterwebviewFactory(registrar));
    }
}
