package com.gme.p007av.utils;

import android.text.TextUtils;
import android.util.Log;
import com.gme.p007av.BuildConfig;

public final class GMELibLoader {
    public static final String TAG = "GMELibLoader";
    private static boolean mHasLoaded = false;
    private static String mLibraryPath = "";
    private static final Object mLoadLock = new Object();

    public static int loadSdkLibrary() {
        synchronized (mLoadLock) {
            if (!mHasLoaded) {
                boolean zLoadLibrary = loadLibrary("txsoundtouch");
                String str = TAG;
                Log.w(str, "load library txsoundtouch ".concat(String.valueOf(zLoadLibrary)));
                Log.w(str, "load library txffmpeg ".concat(String.valueOf(loadLibrary("txffmpeg"))));
                boolean zLoadLibrary2 = loadLibrary(BuildConfig.NativeSoName);
                Log.w(str, "load library gmesdk ".concat(String.valueOf(zLoadLibrary2)));
                mHasLoaded = zLoadLibrary2;
            }
        }
        return 0;
    }

    private static boolean loadLibrary(String str) {
        try {
            if (!TextUtils.isEmpty(mLibraryPath) ? loadLibrary(mLibraryPath, str) : false) {
                return true;
            }
            Log.w(TAG, "load library " + str + " from system path ");
            System.loadLibrary(str);
            return true;
        } catch (Error | Exception e) {
            Log.w(TAG, "load library : " + e.toString());
            return false;
        }
    }

    public static boolean loadLibrary(String str, String str2) {
        try {
            if (TextUtils.isEmpty(str)) {
                return false;
            }
            Log.w(TAG, "load library " + str2 + " from path " + str);
            System.load(str + "/lib" + str2 + ".so");
            return true;
        } catch (Error | Exception e) {
            Log.w(TAG, "load library : " + e.toString());
            return false;
        }
    }

    public static String getLibraryPath() {
        return mLibraryPath;
    }

    public static void setLibraryPath(String str) {
        Log.w(TAG, "setLibraryPath ".concat(String.valueOf(str)));
        mLibraryPath = str;
    }

    public static boolean isLoadLibrary() {
        return mHasLoaded;
    }
}
