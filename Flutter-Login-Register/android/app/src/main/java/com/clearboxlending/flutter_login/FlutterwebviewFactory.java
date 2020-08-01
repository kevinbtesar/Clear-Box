package com.clearboxlending.flutter_login;

import android.content.Context;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

import static io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterwebviewFactory extends PlatformViewFactory {

    private final Registrar mPluginRegistrar;

    public FlutterwebviewFactory(Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        mPluginRegistrar = registrar;
    }

    @Override
    public PlatformView create(Context context, int i, Object o) {
        return new FlutterWeb(context, mPluginRegistrar, i);
    }

}
