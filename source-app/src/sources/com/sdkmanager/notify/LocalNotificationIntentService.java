package com.sdkmanager.notify;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.sdkmanager.AppUtilManager;

public class LocalNotificationIntentService extends IntentService {
    public LocalNotificationIntentService() {
        super("com.sdkmanager.notify.LocalNotificationIntentService");
    }

    @Override
    public final void onHandleIntent(Intent intent) {
        if (intent == null) {
            return;
        }
        Context applicationContext = getApplicationContext();
        boolean zIsAppInForeground = AppUtilManager.isAppInForeground(applicationContext);
        if (zIsAppInForeground) {
            Log.d("im-debug", "@@ LocalNotificationIntentService: App is running in foreground");
        } else {
            Log.d("im-debug", "@@ LocalNotificationIntentService: App is running in background");
        }
        if (intent.getExtras() != null) {
            new LocalNotificationManager(applicationContext).setPushTime(intent.getExtras().getString(LocalNotificationManager.PUSH_TIME));
            PushRecordManager pushRecordManager = new PushRecordManager(applicationContext);
            pushRecordManager.setPushTag(intent.getExtras().getString(LocalNotificationManager.PUSH_TAG));
            pushRecordManager.setPushIdToCache(intent.getExtras().getString(LocalNotificationManager.PUSH_ID));
        }
        if (zIsAppInForeground) {
            return;
        }
        Intent intent2 = new Intent("android.intent.action.MAIN");
        intent2.setClassName(applicationContext, LocalNotificationManager.MAIN_ACTIVITY_CLASS_NAME);
        intent2.setFlags(268435456);
        intent2.addCategory("android.intent.category.LAUNCHER");
        if (intent.hasExtra(LocalNotificationManager.PUSH_ID)) {
            intent2.putExtra("pushId", intent.getStringExtra(LocalNotificationManager.PUSH_ID));
        }
        Log.d("im-debug", "@@ LAUNCH: " + intent2.toString() + " -> " + intent2.getExtras().toString());
        try {
            applicationContext.startActivity(intent2);
        } catch (Exception e) {
            Log.d("im-debug", "?? LAUNCH: " + e.toString());
        }
    }
}
