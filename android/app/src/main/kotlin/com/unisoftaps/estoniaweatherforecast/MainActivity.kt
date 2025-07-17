package com.unisoftaps.estoniaweatherforecast

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.unisoftaps.estoniaweatherforecast/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidget" -> {
                    val counter = call.argument<Int>("counter") ?: 0
                    updateAllWidgets(counter)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun updateAllWidgets(counter: Int) {
        val context = this
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = ComponentName(context, MyAppWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

        for (appWidgetId in appWidgetIds) {
            MyAppWidgetProvider.updateWidget(context, appWidgetManager, appWidgetId, counter)
        }
    }
}