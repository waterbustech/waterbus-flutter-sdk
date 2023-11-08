package com.waterbus.waterbus_sdk

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.getSystemService
import com.waterbus.waterbus_sdk.Services.ShareScreenService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WaterbusSdkPlugin */
class WaterbusSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var mContext : Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "waterbus-sdk/native-plugin")
      channel.setMethodCallHandler(this)
      mContext = flutterPluginBinding.applicationContext
      registerForegroundServiceId()
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
          result.success("${android.os.Build.VERSION.RELEASE}")
        }
        "startForeground" -> {
            val intent = Intent(mContext, ShareScreenService::class.java)
            intent.action = "start"
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                mContext.startForegroundService(intent)
                result.success(true)
            } else {
                mContext.startService(intent)
                result.success(true)
            }
        }
        "stopForeground" -> {
            val intent = Intent(mContext, ShareScreenService::class.java)
            intent.action = "stop"
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                mContext.startForegroundService(intent)
                result.success(true)
            } else {
                mContext.startService(intent)
                result.success(true)
            }
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

    private fun registerForegroundServiceId() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = mContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            @SuppressLint("WrongConstant") val notificationChannel = NotificationChannel(
                ShareScreenService.CHANNEL_ID,
                ShareScreenService.CHANNEL_ID,
                NotificationManager.IMPORTANCE_DEFAULT
            )
            notificationChannel.description = ShareScreenService.CHANNEL_ID
            notificationManager.createNotificationChannel(notificationChannel)
        }
    }
}
