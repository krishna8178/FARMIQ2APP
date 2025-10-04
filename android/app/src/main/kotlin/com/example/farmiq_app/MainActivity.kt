package com.example.my_flutter_app // Change this to your flutter app's package name

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    // 1. Define a channel name
    private val BROADCAST_CHANNEL = "com.example.my_flutter_app/broadcast"

    // 2. Define your broadcast action
    // THIS MUST MATCH THE ACTION YOU SEND FROM THE TEST APP
    private val MY_BROADCAST_ACTION = "com.yourapp.MY_CUSTOM_ACTION"

    private var broadcastReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 3. Set up the EventChannel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BROADCAST_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    // When Dart starts listening, create and register the receiver
                    broadcastReceiver = createBroadcastReceiver(events)
                    registerReceiver(broadcastReceiver, IntentFilter(MY_BROADCAST_ACTION))
                    println("BroadcastReceiver registered")
                }

                override fun onCancel(arguments: Any?) {
                    // When Dart stops listening, unregister the receiver
                    unregisterReceiver(broadcastReceiver)
                    broadcastReceiver = null
                    println("BroadcastReceiver unregistered")
                }
            }
        )
    }

    // 4. Helper function to create the BroadcastReceiver
    private fun createBroadcastReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                // When a broadcast is received, send its data to Flutter
                val dataKey = "my_extra_data" // This is the key you used in the sender app
                val data = intent?.getStringExtra(dataKey)
                events?.success(data ?: "No data received")
            }
        }
    }
}