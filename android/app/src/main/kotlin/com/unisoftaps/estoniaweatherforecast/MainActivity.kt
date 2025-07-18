package com.unisoftaps.estoniaweatherforecast

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.unisoftaps.estoniaweatherforecast/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidget" -> {
                        try {
                            val weatherData = mutableMapOf<String, String>()
                            weatherData["cityName"] = call.argument<String>("cityName") ?: "Unknown"
                            weatherData["temperature"] = call.argument<String>("temperature") ?: "--"
                            weatherData["condition"] = call.argument<String>("condition") ?: "Loading..."
                            weatherData["iconUrl"] = call.argument<String>("iconUrl") ?: ""
                            weatherData["minTemp"] = call.argument<String>("minTemp") ?: "--"
                            weatherData["maxTemp"] = call.argument<String>("maxTemp") ?: "--"

                            updateAllWidgets(weatherData)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("UPDATE_ERROR", "Failed to update widget: ${e.message}", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun updateAllWidgets(weatherData: Map<String, String>) {
        val context: Context = this
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = ComponentName(context, MyAppWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

        for (appWidgetId in appWidgetIds) {
            MyAppWidgetProvider.updateWidget(context, appWidgetManager, appWidgetId, weatherData)
        }
    }
}