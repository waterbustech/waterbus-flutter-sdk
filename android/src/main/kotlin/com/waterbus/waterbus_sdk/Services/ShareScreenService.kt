package com.waterbus.waterbus_sdk.Services

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import android.os.Process
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat

class ShareScreenService : Service() {
    private val notificationId = 201
    private var userStopForegroundService = false
    private var isForegroundRunning = false
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        if (intent.action == null) {
            return START_NOT_STICKY
        }
        when (intent.action) {
            "start" -> startForegroundService()
            "stop" -> stopFlutterForegroundService()
            else -> {}
        }
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "onDestroy")
        if (!userStopForegroundService) {
            Log.d(TAG, "User close app, kill current process to avoid memory leak in other plugin.")
            Process.killProcess(Process.myPid())
        }
    }

    @SuppressLint("WrongConstant")
    private fun startForegroundService() {
        if (!isForegroundRunning) {
            isForegroundRunning = true
            val pm = applicationContext.packageManager
            val notificationIntent = pm.getLaunchIntentForPackage(applicationContext.packageName)
            val pendingIntent = PendingIntent.getActivity(
                this, 0,
                notificationIntent, PendingIntent.FLAG_IMMUTABLE
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val builder = NotificationCompat.Builder(this, CHANNEL_ID)
                    .setSmallIcon(resources.getIdentifier("ic_screen_sharing", "drawable", packageName))
                    .setColor(Color.BLUE)
                    .setContentTitle("Waterbus: Online Meetings")
                    .setContentText("You are sharing your screen")
                    .setCategory(NotificationCompat.CATEGORY_SERVICE)
                    .setContentIntent(pendingIntent)
                    .setUsesChronometer(true)
                    .setOngoing(true)

                if (Build.VERSION.SDK_INT >= 34) {
                    ServiceCompat.startForeground(this, notificationId, builder.build(), FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION)
                } else {
                    startForeground(notificationId, builder.build())
                }
            }
        }
    }

    private fun stopFlutterForegroundService() {
        if (isForegroundRunning) {
            stopForeground(true)
            stopSelf()
            isForegroundRunning = false
            userStopForegroundService = true
        }
    }

    companion object {
        private const val TAG = "ForegroundService"
        const val CHANNEL_ID = "waterbus-sdk/foreground-channel"
    }
}