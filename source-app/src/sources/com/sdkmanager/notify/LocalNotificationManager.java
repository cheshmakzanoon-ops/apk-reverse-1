package com.sdkmanager.notify;

import android.app.NotificationManager;
import android.app.TaskStackBuilder;
import android.app.job.JobInfo;
import android.app.job.JobParameters;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;
import androidx.core.app.NotificationCompat;
import com.google.android.gms.common.api.Api;
import com.sdkmanager.AppUtilManager;
import com.sdkmanager.PushUtilManager;
import com.sdkmanager.SdkManager;
import com.unity3d.player.C1087R;
import java.util.Random;

public class LocalNotificationManager {
    public static final String BODY = "NOTIF_BODY";
    public static final String CACHE_GAME_UID_KEY = "COK_GAMEUID";
    public static final String CACHE_NOTIF_RECORD_KEY = "COK_PUSH_RECORD";
    public static final String CACHE_PUSH_TAG = "LF_PUSH_TAG";
    public static final String CACHE_PUSH_TIME = "LF_PUSH_TIME";
    public static final String CHANNEL_ID = "lf_notify";
    static final String CURRENT_NOTIFICATION_CONTENT = "HFLocalNotificationContent";
    public static final String DEFAULT_NOTIFICATION_CHANNEL = "lf_notify";
    public static final String GOTO_NOTIF_RECORD_KEY = "GOTO_RECORD";
    public static final String HAS_ACTION = "NOTIF_HAS_ACTION";
    public static final String ICON_RESOURCE = "NOTIF_ICON_RESOURCE";
    public static final String MAIN_ACTIVITY_CLASS_NAME = "com.im30.aps.debug.UnityPlayerActivityCustom";
    public static final String MAIN_ACTIVITY_CLASS_NAME_KEY = "com.im30.aps.debug.MainActivityClassNameKey";
    public static final String NOTIFICATION_CODE_KEY = "com.im30.aps.debug.notificationCodeKey";
    static final String NOTIFICATION_UNIQUE_KEY = "com.im30.of.notify";
    public static final String PLAY_SOUND = "NOTIF_PLAY_SOUND";
    public static final String PUSHID_FOR_CLICK = "push_Id_for_click";
    public static final String PUSH_GROUP_KEY = "ls_push_group";
    public static final String PUSH_ID = "pushid";
    public static final String PUSH_MSG = "body";
    public static final String PUSH_PLAYER_MARK = "mark";
    public static final String PUSH_PLAYER_UID = "playerUid";
    public static final String PUSH_RECORD = "cok_push_record";
    public static final String PUSH_TAG = "tag";
    public static final String PUSH_TAG_FOR_CLICK = "tag_for_click";
    public static final String PUSH_TIME = "cok_push_time";
    public static final String PUSH_TYPE = "cok_push_type";
    static final String TAG = "HFLocalNotification";
    public static final String TITLE = "NOTIF_TITLE";
    Context androidActivity;
    Context androidContext;
    NotificationManager notificationManager;

    public static boolean isBlank(String str) {
        int length;
        if (str != null && (length = str.length()) != 0) {
            for (int i = 0; i < length; i++) {
                if (!Character.isWhitespace(str.charAt(i))) {
                    return false;
                }
            }
        }
        return true;
    }

    public void setPushTag(String str) {
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(CACHE_PUSH_TAG, 0).edit();
        editorEdit.putString(PUSH_TAG, str);
        editorEdit.commit();
    }

    public void setPushTime(String str) {
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(CACHE_PUSH_TIME, 0).edit();
        editorEdit.putString(PUSH_TIME, str);
        editorEdit.commit();
    }

    public void SetPushTagToCache(String str) {
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(CACHE_PUSH_TAG, 0).edit();
        editorEdit.putString(PUSH_TAG, str);
        editorEdit.commit();
    }

    public void fireNotificationNew(Context context, Intent intent) {
        if (AppUtilManager.isAppInForeground(context)) {
            if (SdkManager.getInstance().IsAppInForeGround()) {
                return;
            }
            String string = intent.getExtras().getString(PUSH_ID);
            Log.d("im-debug", "!! NewFire: Foreground Return -> " + string);
            SdkManager.getInstance().PostEvent("client_notify_receive", "Foreground " + string);
            return;
        }
        Bundle extras = intent.getExtras();
        String string2 = extras.getString(TITLE);
        String string3 = extras.getString(BODY);
        String string4 = extras.getString(PUSH_TIME);
        SetPushTagToCache(extras.getString(PUSH_TAG));
        String string5 = extras.getString(PUSH_ID);
        Intent intent2 = new Intent("android.intent.action.MAIN");
        intent2.setClassName(context, MAIN_ACTIVITY_CLASS_NAME);
        intent2.setFlags(268435456);
        intent2.addCategory("android.intent.category.LAUNCHER");
        intent2.putExtra(PUSH_ID, string5);
        this.notificationManager.notify(string4.hashCode(), new NotificationCompat.Builder(context, "lf_notify").setSmallIcon(C1087R.drawable.app_icon).setContentTitle(string2).setContentText(string3).setContentIntent(TaskStackBuilder.create(this.androidContext).addNextIntentWithParentStack(intent2).getPendingIntent(new Random().nextInt(Api.BaseClientBuilder.API_PRIORITY_OTHER), 67108864)).setAutoCancel(true).setPriority(2).build());
        Log.d("im-debug", "!! NewFire: " + string2 + " -> " + string5);
        SdkManager.getInstance().PostEvent("client_notify_receive", string5);
    }

    public void fireNotificationNew2(Context context, JobParameters jobParameters) {
        Log.d("im-debug", "fireNotificationNew2");
        if (AppUtilManager.isAppInForeground(context)) {
            Log.d("im-debug", "fireNotificationNew2 return due to App is running in foreground");
            return;
        }
        Log.d("im-debug", "fireNotificationNew2 App is not running");
        PersistableBundle extras = jobParameters.getExtras();
        String string = extras.getString(TITLE);
        String string2 = extras.getString(BODY);
        String string3 = extras.getString(PUSH_TIME);
        String string4 = extras.getString(PUSH_TAG);
        SetPushTagToCache(string4);
        String string5 = extras.getString(PUSH_ID);
        new PushRecordManager(context).RecordToHttp("local", extras.getString(PUSH_PLAYER_UID), string4, extras.getString(PUSH_PLAYER_MARK), string5);
        PushUtilManager.getInstance().AddDataToCache(context, string5);
        Intent intent = new Intent("android.intent.action.MAIN");
        intent.setClassName(context, MAIN_ACTIVITY_CLASS_NAME);
        intent.setFlags(268435456);
        intent.addCategory("android.intent.category.LAUNCHER");
        intent.putExtra(PUSH_ID, string5);
        this.notificationManager.notify(string3.hashCode(), new NotificationCompat.Builder(context, "lf_notify").setSmallIcon(C1087R.drawable.app_icon).setContentTitle(string).setContentText(string2).setContentIntent(TaskStackBuilder.create(this.androidContext).addNextIntentWithParentStack(intent).getPendingIntent(new Random().nextInt(Api.BaseClientBuilder.API_PRIORITY_OTHER), 67108864)).setAutoCancel(true).setPriority(2).build());
        Log.d("im-debug", "!! NewFire2: " + string + " -> " + string5);
    }

    public LocalNotificationManager(Context context) {
        this.androidActivity = context;
        Context applicationContext = context.getApplicationContext();
        this.androidContext = applicationContext;
        this.notificationManager = (NotificationManager) applicationContext.getSystemService("notification");
        Log.d("LocalNotifi::initialize", "Called with activity: " + context.toString());
    }

    public void notify(LocalNotification localNotification) {
        scheduleNotifications(localNotification);
    }

    public void cancel(String str) {
        cancelJob(str);
    }

    private void scheduleNotifications(LocalNotification localNotification) {
        try {
            PersistableBundle persistableBundle = new PersistableBundle();
            persistableBundle.putString(TITLE, localNotification.title);
            persistableBundle.putString(BODY, localNotification.body);
            persistableBundle.putString(PUSH_TYPE, localNotification.pushType);
            persistableBundle.putString(PUSH_TIME, String.valueOf(System.currentTimeMillis()));
            persistableBundle.putInt(ICON_RESOURCE, localNotification.iconResourceId);
            persistableBundle.putInt(PLAY_SOUND, localNotification.playSound ? 1 : 0);
            persistableBundle.putInt(HAS_ACTION, localNotification.hasAction ? 1 : 0);
            persistableBundle.putString(PUSH_PLAYER_UID, localNotification.gameUid);
            persistableBundle.putString(PUSH_PLAYER_MARK, localNotification.playerMark);
            persistableBundle.putString(PUSH_ID, localNotification.pushId);
            persistableBundle.putString(MAIN_ACTIVITY_CLASS_NAME_KEY, MAIN_ACTIVITY_CLASS_NAME);
            long time = localNotification.fireDate.getTime() - System.currentTimeMillis();
            Log.d("im-debug", "scheduleNotifications send notify after " + time + " mseconds with body");
            JobScheduler jobScheduler = (JobScheduler) this.androidContext.getSystemService("jobscheduler");
            JobInfo.Builder builder = new JobInfo.Builder(localNotification.pushType.hashCode(), new ComponentName(this.androidContext, NotificationJobService.class.getName()));
            builder.setRequiresCharging(false);
            builder.setRequiredNetworkType(1);
            builder.setMinimumLatency(time);
            builder.setOverrideDeadline(time + 1000);
            builder.setExtras(persistableBundle);
            jobScheduler.schedule(builder.build());
        } catch (Exception e) {
            Log.e("im-debug", "scheduleNotifications failure." + e.getMessage());
            e.printStackTrace();
        }
    }

    public void cancelJob(String str) {
        try {
            ((JobScheduler) this.androidContext.getSystemService("jobscheduler")).cancel(str.hashCode());
        } catch (Exception e) {
            Log.d("im-debug", "cancelJob Exception: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void cancelAllJob() {
        try {
            ((JobScheduler) this.androidContext.getSystemService("jobscheduler")).cancelAll();
        } catch (Exception e) {
            Log.d("im-debug", "cancelAllJob Exception: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void cancelAll() {
        cancelAllJob();
    }

    public void clearAllNotifications() {
        this.notificationManager.cancelAll();
        cancelAll();
        Log.d("im-debug", "^^ Clear all notifications.");
    }

    private SharedPreferences getNotificationContentSP() {
        return this.androidContext.getSharedPreferences(CURRENT_NOTIFICATION_CONTENT, 0);
    }

    public void unpersistNotification(String str) {
        Log.d("unpersistNotif", "Notification: " + str);
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(TAG, 0).edit();
        editorEdit.remove(str);
        editorEdit.commit();
    }

    public void unpersistAllNotifications() {
        Log.d("unpersistAllNot", "Called");
        SharedPreferences.Editor editorEdit = this.androidContext.getSharedPreferences(TAG, 0).edit();
        editorEdit.clear();
        editorEdit.commit();
    }
}
