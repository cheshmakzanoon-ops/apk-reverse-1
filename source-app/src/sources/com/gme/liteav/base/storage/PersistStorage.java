package com.gme.liteav.base.storage;

import android.content.SharedPreferences;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.annotations.JNINamespace;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;

@JNINamespace("liteav")
public class PersistStorage {
    public static final String GLOBAL_DOMAIN = "com.liteav.storage.global";
    private static final String LITEAV_PERSIST_STORAGE_SP_NAME = "com.liteav.persist.storage";
    private String mDomain;
    private final SharedPreferences.Editor mEditor;
    private final SharedPreferences mSharedPreferences;

    public PersistStorage(String str) {
        this(str, false);
    }

    public PersistStorage(String str, boolean z) {
        initializeDomain(str, z);
        SharedPreferences sharedPreferences = ContextUtils.getApplicationContext().getSharedPreferences(z ? str : LITEAV_PERSIST_STORAGE_SP_NAME, 0);
        this.mSharedPreferences = sharedPreferences;
        this.mEditor = sharedPreferences.edit();
    }

    private void initializeDomain(String str, boolean z) {
        if (!z) {
            if (str == null || str.isEmpty()) {
                this.mDomain = "null|";
                return;
            }
            this.mDomain = str + "|";
            return;
        }
        this.mDomain = "";
    }

    public void put(String str, int i) {
        this.mEditor.putInt(this.mDomain + str, i);
    }

    public void put(String str, long j) {
        this.mEditor.putLong(this.mDomain + str, j);
    }

    public void put(String str, String str2) {
        this.mEditor.putString(this.mDomain + str, str2);
    }

    public void clear(String str) {
        this.mEditor.remove(this.mDomain + str);
    }

    public void commit() {
        this.mEditor.apply();
    }

    public Integer getInt(String str) {
        if (!this.mSharedPreferences.contains(this.mDomain + str)) {
            return null;
        }
        try {
            return Integer.valueOf(this.mSharedPreferences.getInt(this.mDomain + str, -1));
        } catch (Throwable unused) {
            return null;
        }
    }

    public Long getLong(String str) {
        if (!this.mSharedPreferences.contains(this.mDomain + str)) {
            return null;
        }
        try {
            return Long.valueOf(this.mSharedPreferences.getLong(this.mDomain + str, -1L));
        } catch (Throwable unused) {
            return null;
        }
    }

    public String getString(String str) {
        if (!this.mSharedPreferences.contains(this.mDomain + str)) {
            return null;
        }
        try {
            return this.mSharedPreferences.getString(this.mDomain + str, null);
        } catch (Throwable unused) {
            return null;
        }
    }

    private String[] filterSet(Set<String> set, String str) {
        if (str == null || str.isEmpty()) {
            return (String[]) set.toArray(new String[set.size()]);
        }
        ArrayList arrayList = new ArrayList();
        for (String str2 : set) {
            if (str2.startsWith(str)) {
                arrayList.add(str2.substring(str.length()));
            }
        }
        String[] strArr = new String[arrayList.size()];
        arrayList.toArray(strArr);
        return strArr;
    }

    public String[] getAllKeys() {
        Map<String, ?> all = this.mSharedPreferences.getAll();
        if (all == null || all.isEmpty()) {
            return new String[0];
        }
        return filterSet(all.keySet(), this.mDomain);
    }

    public static int integerToBase(Integer num) {
        return num.intValue();
    }

    public static long longToBase(Long l) {
        return l.longValue();
    }
}
