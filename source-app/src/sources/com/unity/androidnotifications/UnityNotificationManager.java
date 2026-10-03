package com.unity.androidnotifications;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.BadParcelableException;
import android.os.Build;
import android.os.Bundle;
import android.service.notification.StatusBarNotification;
import android.util.Log;
import com.sdkmanager.utils.Udid$$ExternalSyntheticApiModelOutline0;
import com.unity3d.player.UnityPlayer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class UnityNotificationManager extends BroadcastReceiver {
    protected static final String KEY_CHANNEL_ID = "channelID";
    protected static final String KEY_FIRE_TIME = "fireTime";
    protected static final String KEY_ID = "id";
    protected static final String KEY_INTENT_DATA = "data";
    protected static final String KEY_LARGE_ICON = "largeIcon";
    protected static final String KEY_NOTIFICATION = "unityNotification";
    protected static final String KEY_NOTIFICATION_DISMISSED = "com.unity.NotificationDismissed";
    protected static final String KEY_NOTIFICATION_ID = "com.unity.NotificationID";
    protected static final String KEY_REPEAT_INTERVAL = "repeatInterval";
    protected static final String KEY_SMALL_ICON = "smallIcon";
    protected static final String NOTIFICATION_CHANNELS_SHARED_PREFS = "UNITY_NOTIFICATIONS";
    protected static final String NOTIFICATION_CHANNELS_SHARED_PREFS_KEY = "ChannelIDs";
    protected static final String NOTIFICATION_IDS_SHARED_PREFS = "UNITY_STORED_NOTIFICATION_IDS";
    protected static final String NOTIFICATION_IDS_SHARED_PREFS_KEY = "UNITY_NOTIFICATION_IDS";
    protected static final int SAMSUNG_NOTIFICATION_LIMIT = 500;
    protected static final String TAG_UNITY = "UnityNotifications";
    protected static NotificationCallback mNotificationCallback;
    protected static UnityNotificationManager mUnityNotificationManager;
    protected Activity mActivity;
    public Context mContext;
    protected Class mOpenActivity;
    private static HashMap<Integer, Notification> mScheduledNotifications = new HashMap<>();
    private static HashSet<Integer> mVisibleNotifications = new HashSet<>();
    private static int mSentSinceLastHousekeeping = 0;
    private static boolean mPerformingHousekeeping = false;

    public UnityNotificationManager() {
        this.mContext = null;
        this.mActivity = null;
        this.mOpenActivity = null;
    }

    public UnityNotificationManager(Context context, Activity activity) {
        this.mOpenActivity = null;
        this.mContext = context;
        this.mActivity = activity;
        try {
            boolean z = activity.getPackageManager().getApplicationInfo(activity.getPackageName(), 128).metaData.getBoolean("reschedule_notifications_on_restart");
            Boolean.valueOf(z).getClass();
            if (z) {
                context.getPackageManager().setComponentEnabledSetting(new ComponentName(context, (Class<?>) UnityNotificationRestartOnBootReceiver.class), 1, 1);
            }
            Class<?> openAppActivity = UnityNotificationUtilities.getOpenAppActivity(context, false);
            this.mOpenActivity = openAppActivity;
            if (openAppActivity == null) {
                this.mOpenActivity = activity.getClass();
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(TAG_UNITY, "Failed to load meta-data, NameNotFound: " + e.getMessage());
        } catch (NullPointerException e2) {
            Log.e(TAG_UNITY, "Failed to load meta-data, NullPointer: " + e2.getMessage());
        }
        triggerHousekeeping(context, null);
    }

    public static UnityNotificationManager getNotificationManagerImpl(Context context) {
        return getNotificationManagerImpl(context, (Activity) context);
    }

    public static UnityNotificationManager getNotificationManagerImpl(Context context, Activity activity) {
        UnityNotificationManager unityNotificationManager = mUnityNotificationManager;
        if (unityNotificationManager != null) {
            return unityNotificationManager;
        }
        if (Build.VERSION.SDK_INT >= 26) {
            mUnityNotificationManager = new UnityNotificationManagerOreo(context, activity);
        } else {
            mUnityNotificationManager = new UnityNotificationManager(context, activity);
        }
        return mUnityNotificationManager;
    }

    public NotificationManager getNotificationManager() {
        return getNotificationManager(this.mContext);
    }

    public static NotificationManager getNotificationManager(Context context) {
        return (NotificationManager) context.getSystemService("notification");
    }

    public void setNotificationCallback(NotificationCallback notificationCallback) {
        mNotificationCallback = notificationCallback;
    }

    public void registerNotificationChannel(String str, String str2, int i, String str3, boolean z, boolean z2, boolean z3, boolean z4, long[] jArr, int i2) {
        SharedPreferences sharedPreferences = this.mContext.getSharedPreferences(NOTIFICATION_CHANNELS_SHARED_PREFS, 0);
        HashSet hashSet = new HashSet(sharedPreferences.getStringSet(NOTIFICATION_CHANNELS_SHARED_PREFS_KEY, new HashSet()));
        hashSet.add(str);
        SharedPreferences.Editor editorClear = sharedPreferences.edit().clear();
        editorClear.putStringSet(NOTIFICATION_CHANNELS_SHARED_PREFS_KEY, hashSet);
        editorClear.apply();
        SharedPreferences.Editor editorEdit = this.mContext.getSharedPreferences(getSharedPrefsNameByChannelId(str), 0).edit();
        editorEdit.putString("title", str2);
        editorEdit.putInt("importance", i);
        editorEdit.putString("description", str3);
        editorEdit.putBoolean("enableLights", z);
        editorEdit.putBoolean("enableVibration", z2);
        editorEdit.putBoolean("canBypassDnd", z3);
        editorEdit.putBoolean("canShowBadge", z4);
        editorEdit.putString("vibrationPattern", Arrays.toString(jArr));
        editorEdit.putInt("lockscreenVisibility", i2);
        editorEdit.apply();
    }

    protected static String getSharedPrefsNameByChannelId(String str) {
        return String.format("unity_notification_channel_%s", str);
    }

    protected static NotificationChannelWrapper getNotificationChannel(Context context, String str) {
        if (Build.VERSION.SDK_INT >= 26) {
            return UnityNotificationManagerOreo.getOreoNotificationChannel(context, str);
        }
        SharedPreferences sharedPreferences = context.getSharedPreferences(getSharedPrefsNameByChannelId(str), 0);
        NotificationChannelWrapper notificationChannelWrapper = new NotificationChannelWrapper();
        notificationChannelWrapper.f213id = str;
        notificationChannelWrapper.name = sharedPreferences.getString("title", "undefined");
        notificationChannelWrapper.importance = sharedPreferences.getInt("importance", 3);
        notificationChannelWrapper.description = sharedPreferences.getString("description", "undefined");
        notificationChannelWrapper.enableLights = sharedPreferences.getBoolean("enableLights", false);
        notificationChannelWrapper.enableVibration = sharedPreferences.getBoolean("enableVibration", false);
        notificationChannelWrapper.canBypassDnd = sharedPreferences.getBoolean("canBypassDnd", false);
        notificationChannelWrapper.canShowBadge = sharedPreferences.getBoolean("canShowBadge", false);
        notificationChannelWrapper.lockscreenVisibility = sharedPreferences.getInt("lockscreenVisibility", 1);
        String[] strArrSplit = sharedPreferences.getString("vibrationPattern", "[]").split(",");
        int length = strArrSplit.length;
        long[] jArr = new long[length];
        if (length > 1) {
            for (int i = 0; i < strArrSplit.length; i++) {
                try {
                    jArr[i] = Long.parseLong(strArrSplit[i]);
                } catch (NumberFormatException unused) {
                    jArr[i] = 1;
                }
            }
        }
        if (length <= 1) {
            jArr = null;
        }
        notificationChannelWrapper.vibrationPattern = jArr;
        return notificationChannelWrapper;
    }

    protected NotificationChannelWrapper getNotificationChannel(String str) {
        return getNotificationChannel(this.mContext, str);
    }

    public void deleteNotificationChannel(String str) {
        SharedPreferences sharedPreferences = this.mContext.getSharedPreferences(NOTIFICATION_CHANNELS_SHARED_PREFS, 0);
        HashSet hashSet = new HashSet(sharedPreferences.getStringSet(NOTIFICATION_CHANNELS_SHARED_PREFS_KEY, new HashSet()));
        if (hashSet.contains(str)) {
            hashSet.remove(str);
            SharedPreferences.Editor editorClear = sharedPreferences.edit().clear();
            editorClear.putStringSet(NOTIFICATION_CHANNELS_SHARED_PREFS_KEY, hashSet);
            editorClear.apply();
            this.mContext.getSharedPreferences(getSharedPrefsNameByChannelId(str), 0).edit().clear().apply();
        }
    }

    public Object[] getNotificationChannels() {
        Set<String> stringSet = this.mContext.getSharedPreferences(NOTIFICATION_CHANNELS_SHARED_PREFS, 0).getStringSet(NOTIFICATION_CHANNELS_SHARED_PREFS_KEY, new HashSet());
        ArrayList arrayList = new ArrayList();
        Iterator<String> it = stringSet.iterator();
        while (it.hasNext()) {
            arrayList.add(getNotificationChannel(it.next()));
        }
        return arrayList.toArray();
    }

    public void scheduleNotification(Notification.Builder builder) {
        Notification notificationScheduleAlarmWithNotification;
        Bundle extras = builder.getExtras();
        int i = extras.getInt(KEY_ID, -1);
        long j = extras.getLong(KEY_REPEAT_INTERVAL, -1L);
        long j2 = extras.getLong(KEY_FIRE_TIME, -1L);
        boolean z = j2 - Calendar.getInstance().getTime().getTime() < 1000;
        if (!z || j > 0) {
            if (z) {
                j2 += j;
            }
            Intent intentBuildNotificationIntentUpdateList = buildNotificationIntentUpdateList(this.mContext, i);
            if (intentBuildNotificationIntentUpdateList != null) {
                saveNotification(this.mContext, builder.build());
                notificationScheduleAlarmWithNotification = scheduleAlarmWithNotification(builder, intentBuildNotificationIntentUpdateList, j2);
            } else {
                notificationScheduleAlarmWithNotification = null;
            }
        } else {
            notificationScheduleAlarmWithNotification = null;
        }
        if (z) {
            if (notificationScheduleAlarmWithNotification == null) {
                notificationScheduleAlarmWithNotification = buildNotificationForSending(this.mContext, this.mOpenActivity, builder);
            }
            notify(this.mContext, i, notificationScheduleAlarmWithNotification);
        }
    }

    Notification scheduleAlarmWithNotification(Notification.Builder builder, Intent intent, long j) {
        return scheduleAlarmWithNotification(this.mContext, this.mOpenActivity, builder, intent, j);
    }

    static Notification scheduleAlarmWithNotification(Context context, Class cls, Notification.Builder builder, Intent intent, long j) {
        Bundle extras = builder.getExtras();
        int i = extras.getInt(KEY_ID, -1);
        long j2 = extras.getLong(KEY_REPEAT_INTERVAL, -1L);
        Notification notificationBuildNotificationForSending = buildNotificationForSending(context, cls, builder);
        putScheduledNotification(Integer.valueOf(i), notificationBuildNotificationForSending);
        intent.putExtra(KEY_NOTIFICATION_ID, i);
        scheduleNotificationIntentAlarm(context, j2, j, getBroadcastPendingIntent(context, i, intent, 134217728));
        return notificationBuildNotificationForSending;
    }

    static void scheduleAlarmWithNotification(Notification.Builder builder, Context context) {
        Class<?> openAppActivity;
        long j = builder.getExtras().getLong(KEY_FIRE_TIME, 0L);
        Intent intentBuildNotificationIntent = buildNotificationIntent(context);
        UnityNotificationManager unityNotificationManager = mUnityNotificationManager;
        if (unityNotificationManager == null || (openAppActivity = unityNotificationManager.mOpenActivity) == null) {
            openAppActivity = UnityNotificationUtilities.getOpenAppActivity(context, true);
        }
        scheduleAlarmWithNotification(context, openAppActivity, builder, intentBuildNotificationIntent, j);
    }

    protected static Notification buildNotificationForSending(Context context, Class cls, Notification.Builder builder) {
        int i = builder.getExtras().getInt(KEY_ID, -1);
        Intent intentBuildOpenAppIntent = buildOpenAppIntent(context, cls);
        intentBuildOpenAppIntent.putExtra(KEY_NOTIFICATION_ID, i);
        builder.setContentIntent(getActivityPendingIntent(context, i, intentBuildOpenAppIntent, 0));
        finalizeNotificationForDisplay(context, builder);
        return builder.build();
    }

    protected static Intent buildOpenAppIntent(Context context, Class cls) {
        Intent intent = new Intent(context, (Class<?>) cls);
        intent.addFlags(805306368);
        return intent;
    }

    private static synchronized Intent buildNotificationIntentUpdateList(Context context, int i) {
        Set<String> scheduledNotificationIDs = getScheduledNotificationIDs(context);
        if (Build.MANUFACTURER.equals("samsung") && scheduledNotificationIDs.size() >= 499) {
            Log.w(TAG_UNITY, String.format("Attempting to schedule more than %1$d notifications. There is a limit of %1$d concurrently scheduled Alarms on Samsung devices either wait for the currently scheduled ones to be triggered or cancel them if you wish to schedule additional notifications.", 500));
            return null;
        }
        Intent intentBuildNotificationIntent = buildNotificationIntent(context);
        HashSet hashSet = new HashSet(scheduledNotificationIDs);
        hashSet.add(String.valueOf(i));
        saveScheduledNotificationIDs(context, hashSet);
        scheduleHousekeeping(context, hashSet);
        return intentBuildNotificationIntent;
    }

    private static synchronized void scheduleHousekeeping(Context context, Set<String> set) {
        int i = mSentSinceLastHousekeeping + 1;
        mSentSinceLastHousekeeping = i;
        if (i > 50) {
            mSentSinceLastHousekeeping = 0;
            triggerHousekeeping(context, set);
        }
    }

    private static synchronized void triggerHousekeeping(final Context context, final Set<String> set) {
        if (set == null) {
            set = getScheduledNotificationIDs(context);
        }
        new Thread(new Runnable() {
            @Override
            public final void run() {
                UnityNotificationManager.lambda$triggerHousekeeping$0(context, set);
            }
        }).start();
    }

    static void lambda$triggerHousekeeping$0(Context context, Set set) {
        try {
            try {
                synchronized (UnityNotificationManager.class) {
                    while (mPerformingHousekeeping) {
                        UnityNotificationManager.class.wait();
                    }
                    mPerformingHousekeeping = true;
                }
                performNotificationHousekeeping(context, set);
                synchronized (UnityNotificationManager.class) {
                    mPerformingHousekeeping = false;
                    UnityNotificationManager.class.notify();
                }
            } catch (InterruptedException unused) {
                Log.e(TAG_UNITY, "Notification housekeeping interrupted");
                synchronized (UnityNotificationManager.class) {
                    mPerformingHousekeeping = false;
                    UnityNotificationManager.class.notify();
                }
            }
        } catch (Throwable th) {
            synchronized (UnityNotificationManager.class) {
                mPerformingHousekeeping = false;
                UnityNotificationManager.class.notify();
                throw th;
            }
        }
    }

    private static void performNotificationHousekeeping(Context context, Set<String> set) {
        Log.d(TAG_UNITY, "Checking for invalid notification IDs still hanging around");
        Set<String> setFindInvalidNotificationIds = findInvalidNotificationIds(context, set);
        synchronized (UnityNotificationManager.class) {
            HashSet hashSet = new HashSet(getScheduledNotificationIDs(context));
            for (String str : setFindInvalidNotificationIds) {
                hashSet.remove(str);
                removeScheduledNotification(Integer.valueOf(str));
            }
            saveScheduledNotificationIDs(context, hashSet);
            mSentSinceLastHousekeeping = 0;
        }
        Iterator<String> it = setFindInvalidNotificationIds.iterator();
        while (it.hasNext()) {
            deleteExpiredNotificationIntent(context, it.next());
        }
    }

    private static Set<String> findInvalidNotificationIds(Context context, Set<String> set) {
        Intent intentBuildNotificationIntent = buildNotificationIntent(context);
        HashSet hashSet = new HashSet();
        for (String str : set) {
            if (getBroadcastPendingIntent(context, Integer.valueOf(str).intValue(), intentBuildNotificationIntent, 536870912) == null) {
                hashSet.add(str);
            }
        }
        for (StatusBarNotification statusBarNotification : getNotificationManager(context).getActiveNotifications()) {
            hashSet.remove(String.valueOf(statusBarNotification.getId()));
        }
        if (UnityPlayer.currentActivity != null) {
            Intent intent = UnityPlayer.currentActivity.getIntent();
            if (intent.hasExtra(KEY_NOTIFICATION_ID)) {
                hashSet.remove(String.valueOf(intent.getExtras().getInt(KEY_NOTIFICATION_ID)));
            }
        }
        return hashSet;
    }

    protected static Intent buildNotificationIntent(Context context) {
        Intent intent = new Intent(context, (Class<?>) UnityNotificationManager.class);
        intent.setFlags(268468224);
        return intent;
    }

    public static PendingIntent getActivityPendingIntent(Context context, int i, Intent intent, int i2) {
        return PendingIntent.getActivity(context, i, intent, i2 | 67108864);
    }

    public static PendingIntent getBroadcastPendingIntent(Context context, int i, Intent intent, int i2) {
        return PendingIntent.getBroadcast(context, i, intent, i2 | 67108864);
    }

    protected static synchronized void saveNotification(Context context, Notification notification) {
        UnityNotificationUtilities.serializeNotification(context.getSharedPreferences(getSharedPrefsNameByNotificationId(Integer.toString(notification.extras.getInt(KEY_ID, -1))), 0), notification);
    }

    protected static String getSharedPrefsNameByNotificationId(String str) {
        return String.format("u_notification_data_%s", str);
    }

    protected static synchronized List<Notification.Builder> loadSavedNotifications(Context context) {
        ArrayList arrayList;
        Notification.Builder builderRecoverBuilder;
        Set<String> scheduledNotificationIDs = getScheduledNotificationIDs(context);
        arrayList = new ArrayList();
        HashSet<String> hashSet = new HashSet();
        for (String str : scheduledNotificationIDs) {
            Object objDeserializeNotification = UnityNotificationUtilities.deserializeNotification(context, context.getSharedPreferences(getSharedPrefsNameByNotificationId(str), 0));
            if (objDeserializeNotification == null) {
                builderRecoverBuilder = null;
            } else if (objDeserializeNotification instanceof Notification.Builder) {
                builderRecoverBuilder = (Notification.Builder) objDeserializeNotification;
            } else {
                builderRecoverBuilder = UnityNotificationUtilities.recoverBuilder(context, (Notification) objDeserializeNotification);
            }
            if (builderRecoverBuilder != null) {
                arrayList.add(builderRecoverBuilder);
            } else {
                hashSet.add(str);
            }
        }
        if (hashSet.size() > 0) {
            HashSet hashSet2 = new HashSet(scheduledNotificationIDs);
            for (String str2 : hashSet) {
                hashSet2.remove(str2);
                deleteExpiredNotificationIntent(context, str2);
            }
            saveScheduledNotificationIDs(context, hashSet2);
        }
        return arrayList;
    }

    private static boolean canScheduleExactAlarms(AlarmManager alarmManager) {
        return Build.VERSION.SDK_INT < 31;
    }

    protected static void scheduleNotificationIntentAlarm(Context context, long j, long j2, PendingIntent pendingIntent) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService("alarm");
        if (j <= 0) {
            if (canScheduleExactAlarms(alarmManager)) {
                alarmManager.setExactAndAllowWhileIdle(0, j2, pendingIntent);
                return;
            } else {
                alarmManager.set(0, j2, pendingIntent);
                return;
            }
        }
        alarmManager.setInexactRepeating(0, j2, j, pendingIntent);
    }

    public int checkNotificationStatus(int i) {
        for (StatusBarNotification statusBarNotification : getNotificationManager().getActiveNotifications()) {
            if (i == statusBarNotification.getId()) {
                return 2;
            }
        }
        return checkIfPendingNotificationIsRegistered(i) ? 1 : 0;
    }

    public boolean checkIfPendingNotificationIsRegistered(int i) {
        return getBroadcastPendingIntent(this.mContext, i, new Intent(this.mActivity, (Class<?>) UnityNotificationManager.class), 536870912) != null;
    }

    public void cancelAllPendingNotificationIntents() {
        final Set<String> scheduledNotificationIDs;
        synchronized (UnityNotificationManager.class) {
            scheduledNotificationIDs = getScheduledNotificationIDs(this.mContext);
            saveScheduledNotificationIDs(this.mContext, new HashSet());
        }
        if (scheduledNotificationIDs.size() > 0) {
            final Context context = this.mContext;
            new Thread(new Runnable() {
                @Override
                public final void run() {
                    UnityNotificationManager.lambda$cancelAllPendingNotificationIntents$1(scheduledNotificationIDs, context);
                }
            }).start();
        }
    }

    static void lambda$cancelAllPendingNotificationIntents$1(Set set, Context context) {
        Iterator it = set.iterator();
        while (it.hasNext()) {
            String str = (String) it.next();
            cancelPendingNotificationIntent(context, Integer.valueOf(str).intValue());
            deleteExpiredNotificationIntent(context, str);
        }
        triggerHousekeeping(context, null);
    }

    private static synchronized Set<String> getScheduledNotificationIDs(Context context) {
        return context.getSharedPreferences(NOTIFICATION_IDS_SHARED_PREFS, 0).getStringSet(NOTIFICATION_IDS_SHARED_PREFS_KEY, new HashSet());
    }

    private static synchronized void saveScheduledNotificationIDs(Context context, Set<String> set) {
        SharedPreferences.Editor editorClear = context.getSharedPreferences(NOTIFICATION_IDS_SHARED_PREFS, 0).edit().clear();
        editorClear.putStringSet(NOTIFICATION_IDS_SHARED_PREFS_KEY, set);
        editorClear.apply();
    }

    public void cancelPendingNotification(int i) {
        synchronized (UnityNotificationManager.class) {
            cancelPendingNotificationIntent(this.mContext, i);
            triggerHousekeeping(this.mContext, null);
        }
    }

    protected static void cancelPendingNotificationIntent(Context context, int i) {
        PendingIntent broadcastPendingIntent = getBroadcastPendingIntent(context, i, new Intent(context, (Class<?>) UnityNotificationManager.class), 536870912);
        if (broadcastPendingIntent != null) {
            if (context != null) {
                ((AlarmManager) context.getSystemService("alarm")).cancel(broadcastPendingIntent);
            }
            broadcastPendingIntent.cancel();
        }
    }

    protected static synchronized void deleteExpiredNotificationIntent(Context context, String str) {
        context.getSharedPreferences(getSharedPrefsNameByNotificationId(str), 0).edit().clear().apply();
    }

    public void cancelDisplayedNotification(int i) {
        getNotificationManager().cancel(i);
    }

    public void cancelAllNotifications() {
        getNotificationManager().cancelAll();
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        Class<?> openAppActivity;
        Notification notificationBuildNotificationForSending;
        int i;
        try {
            Object notificationOrBuilderForIntent = getNotificationOrBuilderForIntent(context, intent);
            if (notificationOrBuilderForIntent != null) {
                if (notificationOrBuilderForIntent instanceof Notification) {
                    notificationBuildNotificationForSending = (Notification) notificationOrBuilderForIntent;
                    i = notificationBuildNotificationForSending.extras.getInt(KEY_ID, -1);
                } else {
                    Notification.Builder builder = (Notification.Builder) notificationOrBuilderForIntent;
                    if (builder == null) {
                        Log.e(TAG_UNITY, "Failed to recover builder, can't send notification");
                        return;
                    }
                    UnityNotificationManager unityNotificationManager = mUnityNotificationManager;
                    if (unityNotificationManager == null || (openAppActivity = unityNotificationManager.mOpenActivity) == null) {
                        openAppActivity = UnityNotificationUtilities.getOpenAppActivity(context, true);
                    }
                    int i2 = builder.getExtras().getInt(KEY_NOTIFICATION_ID, -1);
                    notificationBuildNotificationForSending = buildNotificationForSending(context, openAppActivity, builder);
                    putScheduledNotification(Integer.valueOf(i2), notificationBuildNotificationForSending);
                    i = i2;
                }
                if (notificationBuildNotificationForSending != null) {
                    notify(context, i, notificationBuildNotificationForSending);
                }
            }
        } catch (BadParcelableException e) {
            Log.w(TAG_UNITY, e.toString());
        }
    }

    protected static void notify(Context context, int i, Notification notification) {
        getNotificationManager(context).notify(i, notification);
        try {
            mNotificationCallback.onSentNotification(notification);
        } catch (RuntimeException unused) {
            Log.w(TAG_UNITY, "Can not invoke OnNotificationReceived event when the app is not running!");
        }
    }

    public static Integer getNotificationColor(Notification notification) {
        if (Build.VERSION.SDK_INT < 26 || notification.extras.containsKey("android.colorized")) {
            return Integer.valueOf(notification.color);
        }
        return null;
    }

    public static int getNotificationGroupAlertBehavior(Notification notification) {
        if (Build.VERSION.SDK_INT >= 26) {
            return notification.getGroupAlertBehavior();
        }
        return 0;
    }

    public static void finalizeNotificationForDisplay(Context context, Notification.Builder builder) {
        int iFindResourceIdInContextByName = UnityNotificationUtilities.findResourceIdInContextByName(context, builder.getExtras().getString(KEY_SMALL_ICON));
        if (iFindResourceIdInContextByName == 0) {
            iFindResourceIdInContextByName = context.getApplicationInfo().icon;
        }
        builder.setSmallIcon(iFindResourceIdInContextByName);
        int iFindResourceIdInContextByName2 = UnityNotificationUtilities.findResourceIdInContextByName(context, builder.getExtras().getString(KEY_LARGE_ICON));
        if (iFindResourceIdInContextByName2 != 0) {
            builder.setLargeIcon(BitmapFactory.decodeResource(context.getResources(), iFindResourceIdInContextByName2));
        }
    }

    public Notification.Builder createNotificationBuilder(String str) {
        return createNotificationBuilder(this.mContext, str);
    }

    protected static Notification.Builder createNotificationBuilder(Context context, String str) {
        if (Build.VERSION.SDK_INT < 26) {
            Notification.Builder builder = new Notification.Builder(context);
            NotificationChannelWrapper notificationChannel = getNotificationChannel(context, str);
            int i = -1;
            if (notificationChannel.vibrationPattern != null && notificationChannel.vibrationPattern.length > 0) {
                builder.setDefaults(5);
                builder.setVibrate(notificationChannel.vibrationPattern);
            } else {
                builder.setDefaults(-1);
            }
            builder.setVisibility(notificationChannel.lockscreenVisibility);
            int i2 = notificationChannel.importance;
            if (i2 == 0) {
                i = -2;
            } else if (i2 != 2) {
                i = (i2 == 3 || i2 != 4) ? 0 : 2;
            }
            builder.setPriority(i);
            builder.getExtras().putString(KEY_CHANNEL_ID, str);
            return builder;
        }
        return Udid$$ExternalSyntheticApiModelOutline0.m402m(context, str);
    }

    public static void setNotificationIcon(Notification.Builder builder, String str, String str2) {
        if (str2 == null || (str2.length() == 0 && builder.getExtras().getString(str) != null)) {
            builder.getExtras().remove(str);
        } else {
            builder.getExtras().putString(str, str2);
        }
    }

    public static void setNotificationColor(Notification.Builder builder, int i) {
        if (i != 0) {
            builder.setColor(i);
            if (Build.VERSION.SDK_INT >= 26) {
                builder.setColorized(true);
            }
        }
    }

    public static void setNotificationUsesChronometer(Notification.Builder builder, boolean z) {
        builder.setUsesChronometer(z);
    }

    public static void setNotificationGroupAlertBehavior(Notification.Builder builder, int i) {
        if (Build.VERSION.SDK_INT >= 26) {
            builder.setGroupAlertBehavior(i);
        }
    }

    public static String getNotificationChannelId(Notification notification) {
        if (Build.VERSION.SDK_INT >= 26) {
            return notification.getChannelId();
        }
        return null;
    }

    public static Notification getNotificationFromIntent(Context context, Intent intent) {
        Object notificationOrBuilderForIntent = getNotificationOrBuilderForIntent(context, intent);
        if (notificationOrBuilderForIntent == null) {
            return null;
        }
        if (notificationOrBuilderForIntent instanceof Notification) {
            return (Notification) notificationOrBuilderForIntent;
        }
        return ((Notification.Builder) notificationOrBuilderForIntent).build();
    }

    public static Object getNotificationOrBuilderForIntent(Context context, Intent intent) {
        Object parcelableExtra;
        boolean z = true;
        if (intent.hasExtra(KEY_NOTIFICATION_ID)) {
            int i = intent.getExtras().getInt(KEY_NOTIFICATION_ID);
            parcelableExtra = getScheduledNotification(Integer.valueOf(i));
            if (parcelableExtra == null) {
                parcelableExtra = UnityNotificationUtilities.deserializeNotification(context, context.getSharedPreferences(getSharedPrefsNameByNotificationId(String.valueOf(i)), 0));
                z = false;
            }
        } else if (intent.hasExtra(KEY_NOTIFICATION)) {
            parcelableExtra = intent.getParcelableExtra(KEY_NOTIFICATION);
        } else {
            parcelableExtra = null;
            z = false;
        }
        if (parcelableExtra == null || z) {
            return parcelableExtra;
        }
        if (parcelableExtra instanceof Notification) {
            return UnityNotificationUtilities.recoverBuilder(context, (Notification) parcelableExtra);
        }
        return (Notification.Builder) parcelableExtra;
    }

    public void showNotificationSettings(String str) {
        Intent intent;
        if (Build.VERSION.SDK_INT < 26) {
            intent = new Intent("android.settings.APPLICATION_DETAILS_SETTINGS");
            intent.setData(Uri.fromParts("package", this.mContext.getPackageName(), null));
        } else {
            if (str != null && str.length() > 0) {
                Intent intent2 = new Intent("android.settings.CHANNEL_NOTIFICATION_SETTINGS");
                intent2.putExtra("android.provider.extra.CHANNEL_ID", str);
                intent = intent2;
            } else {
                intent = new Intent("android.settings.APP_NOTIFICATION_SETTINGS");
            }
            intent.putExtra("android.provider.extra.APP_PACKAGE", this.mContext.getPackageName());
        }
        intent.addFlags(268435456);
        this.mActivity.startActivity(intent);
    }

    private static synchronized void putScheduledNotification(Integer num, Notification notification) {
        mScheduledNotifications.put(num, notification);
    }

    private static synchronized Notification getScheduledNotification(Integer num) {
        return mScheduledNotifications.get(num);
    }

    private static synchronized Notification removeScheduledNotification(Integer num) {
        return mScheduledNotifications.remove(num);
    }
}
