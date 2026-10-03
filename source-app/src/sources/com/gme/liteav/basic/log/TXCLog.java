package com.gme.liteav.basic.log;

import com.gme.liteav.base.Log;
import com.gme.liteav.base.util.SoLoader;

@Deprecated
public class TXCLog {
    static {
        SoLoader.loadAllLibraries();
    }

    public static void m1036v(String str, String str2, Object... objArr) {
        m1035v(str, String.format(str2, objArr));
    }

    public static void m1035v(String str, String str2) {
        Log.m950v(str, str2, new Object[0]);
    }

    public static void m1030d(String str, String str2, Object... objArr) {
        m1029d(str, String.format(str2, objArr));
    }

    public static void m1029d(String str, String str2) {
        Log.m947d(str, str2, new Object[0]);
    }

    public static void m1034i(String str, String str2, Object... objArr) {
        m1033i(str, String.format(str2, objArr));
    }

    public static void m1033i(String str, String str2) {
        Log.m949i(str, str2, new Object[0]);
    }

    public static void m1038w(String str, String str2, Object... objArr) {
        m1037w(str, String.format(str2, objArr));
    }

    public static void m1037w(String str, String str2) {
        Log.m951w(str, str2, new Object[0]);
    }

    public static void m1032e(String str, String str2, Object... objArr) {
        m1031e(str, String.format(str2, objArr));
    }

    public static void m1031e(String str, String str2) {
        Log.m948e(str, str2, new Object[0]);
    }
}
