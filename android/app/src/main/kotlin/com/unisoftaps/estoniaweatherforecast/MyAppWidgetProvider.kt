package com.unisoftaps.estoniaweatherforecast

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.*

class MyAppWidgetProvider : AppWidgetProvider() {

    companion object {
        private var currentCounter = 0

        fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, counter: Int) {
            currentCounter = counter
            val views = RemoteViews(context.packageName, R.layout.my_widget_layout)
            views.setTextViewText(R.id.widget_counter, "Counter: $counter")

            val currentTime = SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date())
            views.setTextViewText(R.id.widget_time, "Updated: $currentTime")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (widgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, widgetId, currentCounter)
        }
    }
}