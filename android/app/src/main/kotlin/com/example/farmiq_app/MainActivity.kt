// 1. CORRECTED THE PACKAGE NAME TO MATCH YOUR PROJECT
package com.example.farmiq_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    // 2. UPDATED THE CHANNEL NAME FOR CONSISTENCY
    private val BROADCAST_CHANNEL = "com.example.farmiq_app/broadcast"

    // This must match the action you send from the test app
    private val MY_BROADCAST_ACTION = "com.yourapp.MY_CUSTOM_ACTION"

    private var broadcastReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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