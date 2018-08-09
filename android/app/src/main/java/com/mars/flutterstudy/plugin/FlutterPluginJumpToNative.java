package com.mars.flutterstudy.plugin;

import android.app.Activity;
import android.content.Intent;

import com.mars.flutterstudy.OneActivity;
import com.mars.flutterstudy.TwoActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterPluginJumpToNative implements MethodChannel.MethodCallHandler {

    public static String CHANNEL = "com.jzhu.jump/plugin";
    static MethodChannel channel;
    private Activity activity;

    private FlutterPluginJumpToNative(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        FlutterPluginJumpToNative instance = new FlutterPluginJumpToNative(registrar.activity());
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        //通过MethodCall可以获取参数和方法名，然后再寻找对应的平台业务，本案例做了2个跳转的业务
        //接收来自flutter的指令oneAct
        switch (call.method) {
            case "oneAct": {

                //跳转到指定Activity
                Intent intent = new Intent(activity, OneActivity.class);
                activity.startActivity(intent);

                //返回给flutter的参数
                result.success("success");
                break;
            }
            //接收来自flutter的指令twoAct
            case "twoAct": {

                //解析参数
                String text = call.argument("flutter");

                //带参数跳转到指定Activity
                Intent intent = new Intent(activity, TwoActivity.class);
                intent.putExtra(TwoActivity.VALUE, text);
                activity.startActivity(intent);

                //返回给flutter的参数
                result.success("success");
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

}
