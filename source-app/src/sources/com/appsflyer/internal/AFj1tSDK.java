package com.appsflyer.internal;

public final class AFj1tSDK {
    public int AFInAppEventType;
    public int AFKeystoreWrapper;
    public int valueOf;

    public static void AFKeystoreWrapper(int[] iArr) {
        for (int i = 0; i < iArr.length / 2; i++) {
            int i2 = iArr[i];
            iArr[i] = iArr[(iArr.length - i) - 1];
            iArr[(iArr.length - i) - 1] = i2;
        }
    }

    public static int values(int i) {
        AFj1vSDK aFj1vSDK = AFj1vSDK.AFInAppEventParameterName;
        return ((aFj1vSDK.AFKeystoreWrapper[0][(i >>> 24) & 255] + aFj1vSDK.AFKeystoreWrapper[1][(i >>> 16) & 255]) ^ aFj1vSDK.AFKeystoreWrapper[2][(i >>> 8) & 255]) + aFj1vSDK.AFKeystoreWrapper[3][i & 255];
    }
}
