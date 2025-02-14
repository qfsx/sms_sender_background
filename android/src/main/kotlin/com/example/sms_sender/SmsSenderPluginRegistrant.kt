package com.example.sms_sender

import io.flutter.embedding.engine.plugins.FlutterPlugin

object SmsSenderPluginRegistrant {
    fun registerWith(flutterPlugin: FlutterPlugin.FlutterPluginBinding) {
        val plugin = SmsSenderPlugin()
        plugin.onAttachedToEngine(flutterPlugin)
    }
}
