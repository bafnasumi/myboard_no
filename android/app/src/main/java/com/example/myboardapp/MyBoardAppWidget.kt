package com.example.myboardapp

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import kotlin.random.Random

/**
 * Implementation of App Widget functionality.
 * App Widget Configuration implemented in [MyBoardAppWidgetConfigureActivity]
 */

const val WIDGET_SYNC = "WIDGET_SYNC"
class MyBoardAppWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent?) {
        if(WIDGET_SYNC == intent?.action){
            val appWidgetId = intent.getIntExtra("appWidgetId", 0)
            updateAppWidget(context, AppWidgetManager.getInstance(context), appWidgetId)
        }


        super.onReceive(context, intent)
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        // When the user deletes the widget, delete the preference associated with it.
        for (appWidgetId in appWidgetIds) {
            deleteTitlePref(context, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {

    val intent = Intent(context, MyBoardAppWidget::class.java)
    intent.action = WIDGET_SYNC
    intent.putExtra("appWidgetId", appWidgetId)

    val flag =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE
        else PendingIntent.FLAG_MUTABLE
    //intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
    val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, flag)
    val widgetText = loadTitlePref(context, appWidgetId)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.my_board_app_widget)
    views.setTextViewText(R.id.appwidget_text, Random.nextInt().toString())
    views.setOnClickPendingIntent(R.id.iv_sync, pendingIntent)


    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}