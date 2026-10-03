package com.appsflyer.internal;

import android.content.SharedPreferences;
import com.appsflyer.AFLogger;

public final class AFd1pSDK implements AFd1xSDK {
    private final SharedPreferences AFInAppEventType;

    public AFd1pSDK(SharedPreferences sharedPreferences) {
        this.AFInAppEventType = sharedPreferences;
    }

    @Override
    public final void values(String str, String str2) {
        this.AFInAppEventType.edit().putString(str, str2).apply();
    }

    @Override
    public final String valueOf(String str, String str2) {
        try {
            return this.AFInAppEventType.getString(str, str2);
        } catch (ClassCastException e) {
            AFLogger.afErrorLog("Unexpected data type found for key ".concat(String.valueOf(str)), e);
            return str2;
        }
    }

    @Override
    public final boolean valueOf(String str) {
        try {
            return this.AFInAppEventType.getBoolean(str, false);
        } catch (ClassCastException e) {
            AFLogger.afErrorLog("Unexpected data type found for key ".concat(String.valueOf(str)), e);
            return false;
        }
    }

    @Override
    public final void AFInAppEventParameterName(String str, boolean z) {
        this.AFInAppEventType.edit().putBoolean(str, z).apply();
    }

    @Override
    public final long AFInAppEventType(String str, long j) {
        try {
            return this.AFInAppEventType.getLong(str, j);
        } catch (ClassCastException e) {
            AFLogger.afErrorLog("Unexpected data type found for key ".concat(String.valueOf(str)), e);
            return j;
        }
    }

    @Override
    public final void AFInAppEventParameterName(String str, long j) {
        this.AFInAppEventType.edit().putLong(str, j).apply();
    }

    @Override
    public final void AFInAppEventParameterName(String str, int i) {
        this.AFInAppEventType.edit().putInt(str, i).apply();
    }

    @Override
    public final int valueOf(String str, int i) {
        try {
            return this.AFInAppEventType.getInt(str, i);
        } catch (ClassCastException e) {
            AFLogger.afErrorLog("Unexpected data type found for key ".concat(String.valueOf(str)), e);
            return i;
        }
    }

    @Override
    public final boolean AFInAppEventParameterName(String str) {
        return this.AFInAppEventType.contains(str);
    }

    @Override
    public final void AFKeystoreWrapper(String str) {
        this.AFInAppEventType.edit().remove(str).apply();
    }
}
