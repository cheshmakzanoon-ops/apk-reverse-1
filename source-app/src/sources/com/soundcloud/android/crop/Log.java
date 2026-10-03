package com.soundcloud.android.crop;

class Log {
    private static final String TAG = "android-crop";

    Log() {
    }

    public static void m439e(String str) {
        android.util.Log.e(TAG, str);
    }

    public static void m440e(String str, Throwable th) {
        android.util.Log.e(TAG, str, th);
    }
}
