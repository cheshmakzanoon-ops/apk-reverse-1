package com.ishumei.smantifraud;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Base64;

public class l111l11111I1l {
    public static int l1111l111111Il = 0;
    public static final String l111l11111I1l = "di";
    public static final String l111l11111lIl = "auc";

    public static int l1111l111111Il(Context context) {
        if (context == null) {
            return 0;
        }
        int i = l1111l111111Il;
        if (i != 0) {
            return i;
        }
        try {
            SharedPreferences sharedPreferences = context.getSharedPreferences("auc", 0);
            int i2 = sharedPreferences.getInt("auc", 0) + 1;
            sharedPreferences.edit().putInt("auc", i2).apply();
            l1111l111111Il = i2;
            return i2;
        } catch (Throwable unused) {
            return 0;
        }
    }

    public static void l1111l111111Il(Context context, String str) {
        try {
            context.getSharedPreferences("auc", 0).edit().putString(l111l11111I1l, Base64.encodeToString(str.getBytes(), 2)).apply();
        } catch (Throwable unused) {
        }
    }

    public static String l111l11111lIl(Context context) {
        try {
            return new String(Base64.decode(context.getSharedPreferences("auc", 0).getString(l111l11111I1l, null), 2));
        } catch (Throwable unused) {
            return null;
        }
    }
}
