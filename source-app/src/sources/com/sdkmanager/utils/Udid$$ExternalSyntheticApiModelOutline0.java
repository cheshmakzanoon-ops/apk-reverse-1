package com.sdkmanager.utils;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.usage.StorageStatsManager;
import android.content.Context;
import android.media.ExifInterface;
import android.security.KeyStoreException;
import java.io.InputStream;

public final class Udid$$ExternalSyntheticApiModelOutline0 {
    public static Notification.Builder m402m(Context context, String str) {
        return new Notification.Builder(context, str);
    }

    public static NotificationChannel m403m(Object obj) {
        return (NotificationChannel) obj;
    }

    public static NotificationChannel m404m(String str, CharSequence charSequence, int i) {
        return new NotificationChannel(str, charSequence, i);
    }

    public static StorageStatsManager m406m(Object obj) {
        return (StorageStatsManager) obj;
    }

    public static ExifInterface m409m(InputStream inputStream) {
        return new ExifInterface(inputStream);
    }

    public static KeyStoreException m410m(Object obj) {
        return (KeyStoreException) obj;
    }

    public static void m422m() {
    }

    public static boolean m436m(Object obj) {
        return obj instanceof KeyStoreException;
    }
}
