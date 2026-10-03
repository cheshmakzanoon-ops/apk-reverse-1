package com.joke.connectdevice.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;

public class BmAutoConfig {
    public static final String SHARE_NAME = "bmsdk_auto_config";

    public static void setBoolean(Context context, boolean value, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return;
        }
        context.getSharedPreferences(SHARE_NAME, 0).edit().putBoolean(key, value).apply();
    }

    public static boolean setBooleanCommit(Context context, boolean value, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return false;
        }
        return context.getSharedPreferences(SHARE_NAME, 0).edit().putBoolean(key, value).commit();
    }

    public static boolean getBoolean(Context context, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return false;
        }
        SharedPreferences sharedPreferences = context.getSharedPreferences(SHARE_NAME, 0);
        return sharedPreferences.getBoolean(key, false);
    }

    public static float getFloat(Context context, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return 0.0f;
        }
        SharedPreferences sharedPreferences = context.getSharedPreferences(SHARE_NAME, 0);
        return sharedPreferences.getFloat(key, 0.0f);
    }

    public static int getInt(Context context, String key, int defaultValue) {
        if (context == null || TextUtils.isEmpty(key)) {
            return defaultValue;
        }
        SharedPreferences sharedPreferences = context.getSharedPreferences(SHARE_NAME, 0);
        return sharedPreferences.getInt(key, defaultValue);
    }

    public static void setFloat(Context context, float value, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return;
        }
        context.getSharedPreferences(SHARE_NAME, 0).edit().putFloat(key, value).apply();
    }

    public static void setInt(Context context, int value, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return;
        }
        context.getSharedPreferences(SHARE_NAME, 0).edit().putInt(key, value).apply();
    }

    public static boolean setIntCommit(Context context, int value, String key) {
        if (context == null || TextUtils.isEmpty(key)) {
            return false;
        }
        return context.getSharedPreferences(SHARE_NAME, 0).edit().putInt(key, value).commit();
    }

    private BmAutoConfig() {
    }
}
