package com.mars.flutterstudy;

import android.os.Bundle;
import com.mars.flutterstudy.plugin.FlutterPluginAMap;
import com.mars.flutterstudy.plugin.FlutterPluginCounter;
import com.mars.flutterstudy.plugin.FlutterPluginJumpToNative;
import com.mars.flutterstudy.plugin.FlutterPluginPermissions;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        GeneratedPluginRegistrant.registerWith(this);
        registerCustomPlugin(this);
    }

    private static void registerCustomPlugin(PluginRegistry registrar) {

        FlutterPluginJumpToNative.registerWith(registrar.registrarFor(FlutterPluginJumpToNative.CHANNEL));
        FlutterPluginCounter.registerWith(registrar.registrarFor(FlutterPluginCounter.CHANNEL));
        FlutterPluginPermissions.registerWith(registrar.registrarFor(FlutterPluginPermissions.CHANNEL));
        FlutterPluginAMap.registerWith(registrar.registrarFor(FlutterPluginAMap.EVENT_CHANNEL));

    }

}




