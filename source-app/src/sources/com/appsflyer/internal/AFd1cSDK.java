package com.appsflyer.internal;

import kotlin.Pair;
import kotlin.jvm.internal.Intrinsics;

public final class AFd1cSDK {
    public static boolean AFInAppEventType(String str, String str2) {
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(str2, "");
        int iAFInAppEventParameterName = AFc1uSDK.AFInAppEventParameterName(str);
        int iAFInAppEventParameterName2 = AFc1uSDK.AFInAppEventParameterName(str2);
        Pair<Integer, Integer> pairValueOf = AFe1wSDK.valueOf(str2);
        Pair<Integer, Integer> pairAFKeystoreWrapper = AFe1wSDK.AFKeystoreWrapper(str2);
        if (iAFInAppEventParameterName2 != -1 && pairValueOf == null) {
            return iAFInAppEventParameterName2 == iAFInAppEventParameterName;
        }
        if (pairAFKeystoreWrapper != null) {
            return ((Number) pairAFKeystoreWrapper.getFirst()).intValue() <= iAFInAppEventParameterName && iAFInAppEventParameterName <= ((Number) pairAFKeystoreWrapper.getSecond()).intValue();
        }
        return pairValueOf != null && ((Number) pairValueOf.getFirst()).intValue() <= iAFInAppEventParameterName && iAFInAppEventParameterName <= ((Number) pairValueOf.getSecond()).intValue();
    }
}
