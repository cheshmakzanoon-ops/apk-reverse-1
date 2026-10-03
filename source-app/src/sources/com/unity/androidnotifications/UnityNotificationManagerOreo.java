package com.unity.androidnotifications;

import android.app.Activity;
import android.app.NotificationChannel;
import android.content.Context;
import com.sdkmanager.utils.Udid$$ExternalSyntheticApiModelOutline0;
import java.util.ArrayList;
import java.util.Iterator;

public class UnityNotificationManagerOreo extends UnityNotificationManager {
    static final boolean $assertionsDisabled = false;

    public UnityNotificationManagerOreo(Context context, Activity activity) {
        super(context, activity);
    }

    @Override
    public void registerNotificationChannel(String str, String str2, int i, String str3, boolean z, boolean z2, boolean z3, boolean z4, long[] jArr, int i2) {
        NotificationChannel notificationChannelM404m = Udid$$ExternalSyntheticApiModelOutline0.m404m(str, str2, i);
        notificationChannelM404m.setDescription(str3);
        notificationChannelM404m.enableLights(z);
        notificationChannelM404m.enableVibration(z2);
        notificationChannelM404m.setBypassDnd(z3);
        notificationChannelM404m.setShowBadge(z4);
        notificationChannelM404m.setVibrationPattern(jArr);
        notificationChannelM404m.setLockscreenVisibility(i2);
        getNotificationManager().createNotificationChannel(notificationChannelM404m);
    }

    protected static NotificationChannelWrapper getOreoNotificationChannel(Context context, String str) {
        new ArrayList();
        Iterator it = getNotificationManager(context).getNotificationChannels().iterator();
        while (it.hasNext()) {
            NotificationChannel notificationChannelM403m = Udid$$ExternalSyntheticApiModelOutline0.m403m(it.next());
            if (notificationChannelM403m.getId() == str) {
                return notificationChannelToWrapper(notificationChannelM403m);
            }
        }
        return null;
    }

    protected static NotificationChannelWrapper notificationChannelToWrapper(NotificationChannel notificationChannel) {
        NotificationChannelWrapper notificationChannelWrapper = new NotificationChannelWrapper();
        notificationChannelWrapper.f213id = notificationChannel.getId();
        notificationChannelWrapper.name = notificationChannel.getName().toString();
        notificationChannelWrapper.importance = notificationChannel.getImportance();
        notificationChannelWrapper.description = notificationChannel.getDescription();
        notificationChannelWrapper.enableLights = notificationChannel.shouldShowLights();
        notificationChannelWrapper.enableVibration = notificationChannel.shouldVibrate();
        notificationChannelWrapper.canBypassDnd = notificationChannel.canBypassDnd();
        notificationChannelWrapper.canShowBadge = notificationChannel.canShowBadge();
        notificationChannelWrapper.vibrationPattern = notificationChannel.getVibrationPattern();
        notificationChannelWrapper.lockscreenVisibility = notificationChannel.getLockscreenVisibility();
        return notificationChannelWrapper;
    }

    @Override
    public void deleteNotificationChannel(String str) {
        getNotificationManager().deleteNotificationChannel(str);
    }

    @Override
    public NotificationChannelWrapper[] getNotificationChannels() {
        ArrayList arrayList = new ArrayList();
        Iterator it = getNotificationManager().getNotificationChannels().iterator();
        while (it.hasNext()) {
            arrayList.add(notificationChannelToWrapper(Udid$$ExternalSyntheticApiModelOutline0.m403m(it.next())));
        }
        return (NotificationChannelWrapper[]) arrayList.toArray(new NotificationChannelWrapper[arrayList.size()]);
    }
}
