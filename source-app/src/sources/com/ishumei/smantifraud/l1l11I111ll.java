package com.ishumei.smantifraud;

import android.content.ContentResolver;
import android.content.Context;
import android.os.Build;
import android.os.SystemClock;
import android.provider.Settings;
import java.util.ArrayList;
import java.util.Collections;

public class l1l11I111ll {
    public static String l1111l111111Il() {
        String str;
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            return (context == null || (str = (String) l1l11lI1lIl.l1111l111111Il("android.provider.Settings$Secure", "getString", new Class[]{ContentResolver.class, String.class}, new Object[]{context.getContentResolver(), "android_id"})) == null) ? "" : str;
        } catch (Exception unused) {
            return "";
        }
    }

    public static long l111l11111I1l() {
        try {
            ArrayList arrayList = new ArrayList();
            for (int i = 0; i < 11; i++) {
                arrayList.add(Long.valueOf(l111l11111Il()));
            }
            Collections.sort(arrayList);
            return ((Long) arrayList.get(5)).longValue();
        } catch (Exception unused) {
            return l111l11111Il();
        }
    }

    public static long l111l11111Il() {
        return System.currentTimeMillis() - SystemClock.elapsedRealtime();
    }

    public static int l111l11111lIl() {
        try {
            if (Build.VERSION.SDK_INT >= 24) {
                return Settings.Global.getInt(l11l11l111Il.l1111l111111Il.getContentResolver(), "boot_count");
            }
            return -1;
        } catch (Exception unused) {
            return -1;
        }
    }

    public static int l111l1111l1Il() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return -1;
        }
        try {
            return ((Integer) l1l11lI1lIl.l1111l111111Il("android.provider.Settings$System", "getInt", new Class[]{ContentResolver.class, String.class}, new Object[]{context.getContentResolver(), "screen_brightness"})).intValue();
        } catch (SecurityException unused) {
            return -1001;
        } catch (Exception unused2) {
            return -1;
        }
    }

    public static int l111l1111llIl() {
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            return (context == null || Settings.Secure.getInt(context.getContentResolver(), "mock_location", 0) == 0) ? 0 : 1;
        } catch (Throwable unused) {
            return 0;
        }
    }
}
