package com.appsflyer.internal;

import android.os.Process;
import android.text.TextUtils;
import android.view.ViewConfiguration;

public final class AFf1cSDK {
    private static int $10 = 0;
    private static int $11 = 1;
    private static int AFInAppEventParameterName = 0;
    private static int AFInAppEventType = 1;
    private static long AFKeystoreWrapper;
    private static char[] valueOf;

    static {
        AFKeystoreWrapper();
        TextUtils.indexOf((CharSequence) "", '0', 0, 0);
        TextUtils.lastIndexOf("", '0', 0, 0);
        ViewConfiguration.getPressedStateDuration();
        int i = AFInAppEventParameterName + 1;
        AFInAppEventType = i % 128;
        int i2 = i % 2;
    }

    static void AFKeystoreWrapper() {
        valueOf = new char[]{6229, 30102, 50135, 20764, 44889, 15519, 35523, 6149, 30285, 50052, 20943, 44862, 15728, 35509, 6392, 30265, 50276, 20899, 45028, 15658, 35688, 6304, 30352, 50395, 21018, 41053, 15772, 35763, 6404, 30530, 50313, 21194, 41008, 15987, 35765, 6651, 30524, 50440, 21153, 41188, 15912, 35864, 6573, 30694, 50645, 21264, 41311, 16031, 36033, 6657, 26691, 50568, 21453, 41230, 16246, 36018, 6905, 26700, 50810, 21410, 41446, 16162, 36206, 6874};
        AFKeystoreWrapper = 2927107144130647763L;
    }

    public final AFh1hSDK valueOf(AFh1nSDK aFh1nSDK, String str, String str2, String str3) {
        int i = 2 % 2;
        int i2 = AFInAppEventType;
        int i3 = i2 + 119;
        AFInAppEventParameterName = i3 % 128;
        int i4 = i3 % 2;
        if (aFh1nSDK == null || str2 == null || str3 == null) {
            return new AFh1hSDK(false, AFh1fSDK.INTERNAL_ERROR);
        }
        int i5 = i2 + 63;
        AFInAppEventParameterName = i5 % 128;
        int i6 = i5 % 2;
        return values(aFh1nSDK, str, str2, str3);
    }

    private static AFh1hSDK values(AFh1nSDK aFh1nSDK, String str, String str2, String str3) {
        if (str == null) {
            return new AFh1hSDK(aFh1nSDK.valueOf == AFh1pSDK.DEFAULT, AFh1fSDK.NA);
        }
        String string = "";
        Object[] objArr = new Object[1];
        m793a(TextUtils.indexOf((CharSequence) "", '0', 0) + 65, (char) ((ViewConfiguration.getGlobalActionKeyTimeout() > 0L ? 1 : (ViewConfiguration.getGlobalActionKeyTimeout() == 0L ? 0 : -1)) + 9077), (Process.getThreadPriority(0) + 20) >> 6, objArr);
        String strIntern = ((String) objArr[0]).intern();
        if (aFh1nSDK.valueOf == AFh1pSDK.CUSTOM) {
            string = new StringBuilder(str2).reverse().toString();
        } else {
            str3 = strIntern;
        }
        boolean zEquals = AFInAppEventParameterName(new StringBuilder(str3).reverse().toString(), aFh1nSDK.AFInAppEventParameterName, "android", "v1", string).equals(str);
        return new AFh1hSDK(zEquals, zEquals ? AFh1fSDK.SUCCESS : AFh1fSDK.FAILURE);
    }

    private static java.lang.String AFInAppEventParameterName(java.lang.String r8, java.lang.String r9, java.lang.String r10, java.lang.String r11, java.lang.String r12) {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFf1cSDK.AFInAppEventParameterName(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String):java.lang.String");
    }

    private static void m793a(int i, char c, int i2, Object[] objArr) {
        int i3;
        int i4 = 2 % 2;
        AFj1qSDK aFj1qSDK = new AFj1qSDK();
        long[] jArr = new long[i];
        aFj1qSDK.AFInAppEventParameterName = 0;
        while (aFj1qSDK.AFInAppEventParameterName < i) {
            jArr[aFj1qSDK.AFInAppEventParameterName] = (((long) ((char) (((long) valueOf[i2 + aFj1qSDK.AFInAppEventParameterName]) ^ (-2584935672999232752L)))) ^ (((long) aFj1qSDK.AFInAppEventParameterName) * ((-2584935672999232752L) ^ AFKeystoreWrapper))) ^ ((long) c);
            aFj1qSDK.AFInAppEventParameterName++;
            int i5 = $11 + 103;
            $10 = i5 % 128;
            int i6 = i5 % 2;
        }
        char[] cArr = new char[i];
        aFj1qSDK.AFInAppEventParameterName = 0;
        while (aFj1qSDK.AFInAppEventParameterName < i) {
            int i7 = $11 + 69;
            $10 = i7 % 128;
            if (i7 % 2 != 0) {
                cArr[aFj1qSDK.AFInAppEventParameterName] = (char) jArr[aFj1qSDK.AFInAppEventParameterName];
                i3 = aFj1qSDK.AFInAppEventParameterName % 1;
            } else {
                cArr[aFj1qSDK.AFInAppEventParameterName] = (char) jArr[aFj1qSDK.AFInAppEventParameterName];
                i3 = aFj1qSDK.AFInAppEventParameterName + 1;
            }
            aFj1qSDK.AFInAppEventParameterName = i3;
        }
        objArr[0] = new String(cArr);
    }
}
