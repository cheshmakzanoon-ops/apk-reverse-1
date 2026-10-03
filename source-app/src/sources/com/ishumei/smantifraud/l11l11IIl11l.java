package com.ishumei.smantifraud;

import android.text.TextUtils;
import android.util.Log;

public class l11l11IIl11l {
    public static final String l1111l111111Il = "Smlog.cost";
    public static long l111l11111I1l;
    public static String l111l11111lIl;

    public static void l1111l111111Il() {
        l1111l111111Il((Object) null);
    }

    public static void l1111l111111Il(Object obj) {
        if (TextUtils.isEmpty(l111l11111lIl)) {
            throw new IllegalStateException("no started");
        }
        Log.d(l1111l111111Il, l111l11111lIl + " cost：" + (System.currentTimeMillis() - l111l11111I1l) + ", " + obj);
        l111l11111lIl = null;
    }

    public static void l1111l111111Il(String str) {
        if (!TextUtils.isEmpty(l111l11111lIl)) {
            throw new IllegalStateException("no stopped");
        }
        l111l11111lIl = str;
        l111l11111I1l = System.currentTimeMillis();
    }
}
