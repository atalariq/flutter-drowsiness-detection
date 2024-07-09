package com.riqqq.siperisai

import android.os.Bundle
import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.riqqq.siperisai/volume"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    // This space is intentionally left blank
                }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN || keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            flutterEngine?.let {
                MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("volumeButtonPressed", if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) "down" else "up")
            }
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}