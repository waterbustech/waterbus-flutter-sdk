package com.waterbus.waterbus_sdk.Services

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class ForegroundBootManager : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if ("android.intent.action.BOOT_COMPLETED" == intent.action) {
            val comp =
                ComponentName(context.packageName, ForegroundBootManager::class.java.name)
            val service = context.startService(Intent().setComponent(comp))
            if (null == service) {
                println("Couldn't start service $comp")
            }
        } else {
            println("Received unexpected intent")
        }
    }
}