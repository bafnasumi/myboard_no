package com.example.myboardapp

import android.content.*
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

public class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "com.example.myboardapp/method"
    private lateinit var channel: MethodChannel

    // override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
    //     super.onCreate(savedInstanceState, persistentState)
    //     GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
    // }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // flutterEngine.plugins.add(AudioWaveformsPlugin())

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)

        // Receive data from flutter
        channel.setMethodCallHandler { call, result ->
            if (call.method == "isConnected") {
                val arguments = call.arguments<Map<String, String>>()
                val name = arguments?.get("sumi")
                val batteryLevel = getBatteryLevel()
                result.success(batteryLevel)
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter())
            batteryLevel = intent!!.getIntExtra((BatteryManager.EXTRA_LEVEL), -1)
        }
        return batteryLevel
    }
}
