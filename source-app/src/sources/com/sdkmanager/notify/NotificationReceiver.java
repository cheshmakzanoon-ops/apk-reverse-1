package com.sdkmanager.notify;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import com.sdkmanager.AppUtilManager;
import com.sdkmanager.PushUtilManager;

public class NotificationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("im-debug", "!! Received Alarm: " + AppUtilManager.isAppInForeground(context));
        if (AppUtilManager.isAppInForeground(context)) {
            return;
        }
        try {
            Bundle extras = intent.getExtras();
            if (extras == null) {
                return;
            }
            if (extras.containsKey(LocalNotificationManager.PUSH_TIME)) {
                extras.getString(LocalNotificationManager.PUSH_TIME);
            }
            String string = extras.containsKey(LocalNotificationManager.PUSH_TAG) ? extras.getString(LocalNotificationManager.PUSH_TAG) : "";
            String string2 = extras.containsKey(LocalNotificationManager.PUSH_PLAYER_UID) ? extras.getString(LocalNotificationManager.PUSH_PLAYER_UID) : "";
            String string3 = extras.containsKey(LocalNotificationManager.PUSH_PLAYER_MARK) ? extras.getString(LocalNotificationManager.PUSH_PLAYER_MARK) : "";
            String string4 = extras.containsKey(LocalNotificationManager.PUSH_ID) ? extras.getString(LocalNotificationManager.PUSH_ID) : "";
            Log.d("im-debug", "!! Received Alarm Intent: " + intent.toString() + " -> " + intent.getExtras().toString());
            new PushRecordManager(context).RecordToHttp("local", string2, string, string3, string4);
            PushUtilManager.getInstance().AddDataToCache(context, string4);
            new LocalNotificationManager(context).fireNotificationNew(context, intent);
        } catch (Throwable th) {
            th.printStackTrace();
        }
    }
}
