package com.appsflyer.internal;

import kotlin.jvm.internal.Intrinsics;

public final class AFh1eSDK {
    private final boolean AFInAppEventType;
    public final String AFKeystoreWrapper;
    public final String valueOf;
    public final String values;

    public AFh1eSDK(String str, String str2, String str3, boolean z) {
        Intrinsics.checkNotNullParameter(str, "");
        this.values = str;
        this.valueOf = str2;
        this.AFKeystoreWrapper = str3;
        this.AFInAppEventType = z;
    }

    public final boolean AFInAppEventType() {
        return this.AFInAppEventType;
    }
}
