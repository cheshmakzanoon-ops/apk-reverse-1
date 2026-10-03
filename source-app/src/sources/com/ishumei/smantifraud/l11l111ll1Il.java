package com.ishumei.smantifraud;

import android.content.Context;
import android.content.SharedPreferences;

public class l11l111ll1Il {
    public static final String l1111l111111Il = "bdk";
    public static final String l111l11111lIl = "lc";

    public static String l1111l111111Il(Context context) {
        try {
            return context.getSharedPreferences(l1l11I1l11l.l111l1111l1Il, 0).getString(l1111l111111Il, null);
        } catch (Throwable unused) {
            return null;
        }
    }

    public static void l1111l111111Il(Context context, String str) {
        try {
            context.getSharedPreferences(l1l11I1l11l.l111l1111l1Il, 0).edit().putString(l1111l111111Il, str).apply();
        } catch (Throwable unused) {
        }
    }

    public static boolean l1111l111111Il(Context context, SmAntiFraud.SmOption smOption) {
        if (context == null || smOption == null) {
            return true;
        }
        long disableCollection = smOption.getDisableCollection();
        if (disableCollection < 0) {
            return true;
        }
        return System.currentTimeMillis() - l111l11111lIl(l11l11l111Il.l1111l111111Il) > disableCollection;
    }

    public static void l111l11111I1l(Context context) {
        try {
            SharedPreferences sharedPreferences = context.getSharedPreferences(l1l11I1l11l.l111l1111l1Il, 0);
            if (sharedPreferences.contains(l1111l111111Il)) {
                sharedPreferences.edit().remove(l1111l111111Il).apply();
            }
        } catch (Throwable unused) {
        }
    }

    public static void l111l11111Il(Context context) {
        try {
            context.getSharedPreferences(l1l11I1l11l.l111l1111l1Il, 0).edit().putLong(l111l11111lIl, System.currentTimeMillis()).apply();
        } catch (Throwable unused) {
        }
    }

    public static long l111l11111lIl(Context context) {
        try {
            return context.getSharedPreferences(l1l11I1l11l.l111l1111l1Il, 0).getLong(l111l11111lIl, 0L);
        } catch (Throwable unused) {
            return 0L;
        }
    }
}
