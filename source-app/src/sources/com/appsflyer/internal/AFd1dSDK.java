package com.appsflyer.internal;

import com.gme.trtc.hardwareearmonitor.honor.HonorResultCode;
import java.util.Map;
import kotlin.jvm.internal.Intrinsics;

public final class AFd1dSDK implements AFd1jSDK {
    private final AFd1gSDK AFInAppEventType;

    public AFd1dSDK(AFd1gSDK aFd1gSDK) {
        Intrinsics.checkNotNullParameter(aFd1gSDK, "");
        this.AFInAppEventType = aFd1gSDK;
    }

    @Override
    public final void AFKeystoreWrapper(byte[] bArr, Map<String, String> map, int i) {
        Intrinsics.checkNotNullParameter(bArr, "");
        Intrinsics.checkNotNullParameter(bArr, "");
        if (new AFd1bSDK(bArr, map, HonorResultCode.ADVANCED_RECORD_SUCCESS).AFInAppEventParameterName()) {
            this.AFInAppEventType.AFInAppEventType();
        }
    }
}
