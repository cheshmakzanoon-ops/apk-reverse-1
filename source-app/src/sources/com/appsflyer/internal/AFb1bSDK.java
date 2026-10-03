package com.appsflyer.internal;

import androidx.webkit.ProxyConfig;
import com.appsflyer.AFLogger;

public final class AFb1bSDK {
    private static String AFInAppEventParameterName;
    private static String values;

    static void AFInAppEventParameterName(String str) {
        AFInAppEventParameterName = str;
        if (str == null) {
            return;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            if (i == 0 || i == str.length() - 1) {
                sb.append(str.charAt(i));
            } else {
                sb.append(ProxyConfig.MATCH_ALL_SCHEMES);
            }
        }
        values = sb.toString();
    }

    public static void valueOf(String str) {
        if (AFInAppEventParameterName == null) {
            AFInAppEventParameterName(AFb1vSDK.valueOf().AFInAppEventType().mo785i().registerClient);
        }
        String str2 = AFInAppEventParameterName;
        if (str2 != null) {
            AFLogger.afInfoLog(str.replace(str2, values));
        }
    }
}
