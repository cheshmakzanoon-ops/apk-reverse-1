package com.appsflyer.internal;

import android.content.pm.PackageItemInfo;
import android.content.res.Resources;
import android.os.Bundle;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;

public final class AFd1rSDK {
    private static String values = "281";
    public final AFd1xSDK AFInAppEventParameterName;
    public final AFd1lSDK AFKeystoreWrapper;
    private Bundle valueOf = null;

    public AFd1rSDK(AFd1lSDK aFd1lSDK, AFd1xSDK aFd1xSDK) {
        this.AFKeystoreWrapper = aFd1lSDK;
        this.AFInAppEventParameterName = aFd1xSDK;
    }

    public static String AFInAppEventParameterName() {
        return AppsFlyerProperties.getInstance().getString(AppsFlyerProperties.APP_USER_ID);
    }

    public final String values(String str) {
        Object obj;
        try {
            if (this.valueOf == null) {
                this.valueOf = ((PackageItemInfo) this.AFKeystoreWrapper.AFInAppEventParameterName.getPackageManager().getApplicationInfo(this.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName(), 128)).metaData;
            }
            Bundle bundle = this.valueOf;
            if (bundle == null || (obj = bundle.get(str)) == null) {
                return null;
            }
            return obj.toString();
        } catch (Throwable th) {
            StringBuilder sb = new StringBuilder("Could not load manifest metadata!");
            sb.append(th.getMessage());
            AFLogger.afErrorLog(sb.toString(), th);
            return null;
        }
    }

    public final boolean AFKeystoreWrapper(String str) {
        String strValues = values(str);
        if (strValues != null) {
            return Boolean.parseBoolean(strValues);
        }
        return false;
    }

    public static String AFKeystoreWrapper() {
        StringBuilder sb = new StringBuilder("version: 6.13.0 (build ");
        sb.append(values);
        sb.append(")");
        return sb.toString();
    }

    public final String values() {
        String string = AppsFlyerProperties.getInstance().getString(AppsFlyerProperties.CHANNEL);
        if (string == null) {
            string = values("CHANNEL");
        }
        if (string == null || !string.equals("")) {
            return string;
        }
        return null;
    }

    public final String AFInAppEventType(String str) {
        try {
            int identifier = this.AFKeystoreWrapper.AFInAppEventParameterName.getResources().getIdentifier(str, TypedValues.Custom.S_STRING, this.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
            if (identifier != 0) {
                return this.AFKeystoreWrapper.AFInAppEventParameterName.getString(identifier);
            }
            return null;
        } catch (Resources.NotFoundException e) {
            StringBuilder sb = new StringBuilder("Could not load string resource!");
            sb.append(e.getMessage());
            AFLogger.afErrorLog(sb.toString(), e);
            return null;
        }
    }
}
