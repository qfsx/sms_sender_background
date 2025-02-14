package com.example.sms_sender

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.content.Context

/** SmsSenderPlugin */
class SmsSenderPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private val SMS_PERMISSION_REQUEST_CODE = 123

    private var pendingResult: Result? = null
    private var pendingMethodCall: MethodCall? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.marketing_gateway.sms_sender")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "sendSms" -> {
                if (!checkSmsPermission()) {
                    result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                    return
                }

                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")
                val simSlot = call.argument<Int>("simSlot") ?: 0

                if (phoneNumber == null || message == null) {
                    result.error("INVALID_ARGUMENT", "Phone number and message are required", null)
                    return
                }

                try {
                    val success = sendSms(phoneNumber, message, simSlot)
                    result.success(success)
                } catch (e: Exception) {
                    result.error("SMS_SEND_ERROR", e.message, null)
                }
            }
            "checkSmsPermission" -> {
                result.success(checkSmsPermission())
            }
            "requestSmsPermission" -> {
                if (activity == null) {
                    result.error("ACTIVITY_NULL", "Activity is null", null)
                    return
                }

                if (checkSmsPermission()) {
                    result.success(true)
                    return
                }

                pendingResult = result
                pendingMethodCall = call
                requestSmsPermission()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkSmsPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.SEND_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermission() {
        activity?.let {
            ActivityCompat.requestPermissions(
                it,
                arrayOf(Manifest.permission.SEND_SMS),
                SMS_PERMISSION_REQUEST_CODE
            )
        }
    }

    private fun sendSms(phoneNumber: String, message: String, simSlot: Int): Boolean {
        try {
            Log.d("SmsSender", "Sending SMS to $phoneNumber using SIM slot $simSlot")
            
            val smsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                SmsManager.getSmsManagerForSubscriptionId(simSlot)
            } else {
                SmsManager.getDefault()
            }

            if (message.length > 160) {
                val messageParts = smsManager.divideMessage(message)
                smsManager.sendMultipartTextMessage(phoneNumber, null, messageParts, null, null)
            } else {
                smsManager.sendTextMessage(phoneNumber, null, message, null, null)
            }
            return true
        } catch (e: Exception) {
            Log.e("SmsSender", "Error sending SMS: ${e.message}", e)
            throw e
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
            if (requestCode == SMS_PERMISSION_REQUEST_CODE) {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    pendingResult?.success(true)
                } else {
                    pendingResult?.success(false)
                }
                pendingResult = null
                pendingMethodCall = null
                true
            } else {
                false
            }
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
