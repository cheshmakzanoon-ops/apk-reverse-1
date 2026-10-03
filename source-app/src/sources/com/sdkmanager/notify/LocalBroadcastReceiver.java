package com.sdkmanager.notify;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.sdkmanager.AppUtilManager;

public class LocalBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (AppUtilManager.isAppInForeground(context)) {
            return;
        }
        try {
            new LocalNotificationManager(context).fireNotificationNew(context, intent);
        } catch (Throwable th) {
            th.printStackTrace();
        }
        Log.d("LocalReceiver", "Local notification Intent: " + intent.toString());
    }
}
