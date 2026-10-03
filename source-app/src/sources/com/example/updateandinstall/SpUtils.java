package com.example.updateandinstall;

import android.content.Context;
import android.content.SharedPreferences;

public class SpUtils {
    private static SpUtils instance;

    private SharedPreferences f508sp;

    private SpUtils(Context context) {
        this.f508sp = context.getSharedPreferences("download_sp", 0);
    }

    public static synchronized SpUtils getInstance(Context context) {
        if (instance == null) {
            instance = new SpUtils(context.getApplicationContext());
        }
        return instance;
    }

    public SpUtils putInt(String str, int i) {
        this.f508sp.edit().putInt(str, i).apply();
        return this;
    }

    public int getInt(String str, int i) {
        return this.f508sp.getInt(str, i);
    }

    public SpUtils putLong(String str, long j) {
        this.f508sp.edit().putLong(str, j).apply();
        return this;
    }

    public long getLong(String str, Long l) {
        return this.f508sp.getLong(str, l.longValue());
    }

    public SpUtils putFloat(String str, float f) {
        this.f508sp.edit().putFloat(str, f).apply();
        return this;
    }

    public Float getFloat(String str, Float f) {
        return Float.valueOf(this.f508sp.getFloat(str, f.floatValue()));
    }

    public SpUtils putBoolean(String str, boolean z) {
        this.f508sp.edit().putBoolean(str, z).apply();
        return this;
    }

    public Boolean getBoolean(String str, boolean z) {
        return Boolean.valueOf(this.f508sp.getBoolean(str, z));
    }

    public SpUtils putString(String str, String str2) {
        this.f508sp.edit().putString(str, str2).apply();
        return this;
    }

    public String getString(String str, String str2) {
        return this.f508sp.getString(str, str2);
    }

    public void remove(String str) {
        if (isExist(str)) {
            SharedPreferences.Editor editorEdit = this.f508sp.edit();
            editorEdit.remove(str);
            editorEdit.apply();
        }
    }

    public boolean isExist(String str) {
        return this.f508sp.contains(str);
    }
}
