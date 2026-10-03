package com.appsflyer.internal;

public final class AFc1rSDK {
    public static boolean AFInAppEventType(String str) {
        return str == null || str.length() == 0;
    }

    public static boolean AFKeystoreWrapper(String str) {
        return str == null || str.trim().length() == 0;
    }
}
