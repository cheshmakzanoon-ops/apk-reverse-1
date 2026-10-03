package com.gme.liteav.base;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.preference.PreferenceManager;
import com.gme.liteav.base.annotations.JNINamespace;
import com.unity3d.player.l$a$;
import java.lang.reflect.Method;

@JNINamespace("base::android")
public class ContextUtils {
    static final boolean $assertionsDisabled = false;
    private static final String TAG = "ContextUtils";
    private static Context sApplicationContext;

    static class C1000a {

        private static SharedPreferences f601a = ContextUtils.fetchAppSharedPreferences();
    }

    public static Context getApplicationContext() {
        return sApplicationContext;
    }

    public static void initApplicationContext(Context context) {
        initJavaSideApplicationContext(context);
    }

    public static SharedPreferences fetchAppSharedPreferences() {
        return PreferenceManager.getDefaultSharedPreferences(sApplicationContext);
    }

    public static SharedPreferences getAppSharedPreferences() {
        return C1000a.f601a;
    }

    public static void initApplicationContextForTests(Context context) {
        initJavaSideApplicationContext(context);
        SharedPreferences unused = C1000a.f601a = fetchAppSharedPreferences();
    }

    private static void initJavaSideApplicationContext(Context context) {
        sApplicationContext = context;
    }

    public static AssetManager getApplicationAssets() {
        Context applicationContext = getApplicationContext();
        while (applicationContext instanceof ContextWrapper) {
            applicationContext = ((ContextWrapper) applicationContext).getBaseContext();
        }
        return applicationContext.getAssets();
    }

    public static boolean isIsolatedProcess() {
        return l$a$.ExternalSyntheticApiModelOutline0.m();
    }

    public static Activity activityFromContext(Context context) {
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) {
                return (Activity) context;
            }
            context = ((ContextWrapper) context).getBaseContext();
        }
        return null;
    }

    public static void setDataDirectorySuffix(String str) {
        PathUtils.setPrivateDataDirectorySuffix(str, null);
    }

    public static void initContextFromNative(String str) {
        try {
            Method method = Class.forName("android.app.ActivityThread").getMethod("currentActivityThread", null);
            method.setAccessible(true);
            Object objInvoke = method.invoke(null, null);
            Object objInvoke2 = objInvoke.getClass().getMethod("getApplication", null).invoke(objInvoke, null);
            if (objInvoke2 instanceof Context) {
                initApplicationContext((Context) objInvoke2);
                setDataDirectorySuffix(str);
            }
        } catch (Exception unused) {
        }
    }
}
