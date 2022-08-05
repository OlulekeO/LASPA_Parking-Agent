package com.example.laspa_ok;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class redirect extends FlutterActivity {



    public static MethodChannel methodChannel;
    public final String channelName= "notification";
    NotificationManagerCompat notificationManager;
    public final String NOTIFICATION_ID = "Channel_ID";




    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        notificationManager = NotificationManagerCompat.from(this);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);


        methodChannel = new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                channelName);
        methodChannel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("create")) {

                String batteryLevel = "122";



            }
            if (call.method.equals("destroy")) {
                notificationManager.cancel(0);
                result.success(null);
            }
        });




    }







}





