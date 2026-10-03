package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import java.util.Map;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONObject;

public final class AFc1pSDK implements AFc1kSDK {
    private final AFd1xSDK AFKeystoreWrapper;

    public AFc1pSDK(AFd1xSDK aFd1xSDK) {
        Intrinsics.checkNotNullParameter(aFd1xSDK, "");
        this.AFKeystoreWrapper = aFd1xSDK;
    }

    @Override
    public final Map<String, Object> valueOf() {
        if (this.AFKeystoreWrapper.AFInAppEventParameterName("deeplink_data")) {
            try {
                String strValueOf = this.AFKeystoreWrapper.valueOf("deeplink_data", (String) null);
                return strValueOf == null ? MapsKt.emptyMap() : AFi1eSDK.AFInAppEventType(new JSONObject(strValueOf));
            } catch (Throwable th) {
                AFLogger.afErrorLog("Exception while parsing stored deeplink data", th, true, false);
            }
        }
        return MapsKt.emptyMap();
    }

    @Override
    public final void AFInAppEventParameterName() {
        this.AFKeystoreWrapper.AFKeystoreWrapper("deeplink_data");
    }

    @Override
    public final void valueOf(Map<String, ? extends Object> map) {
        Intrinsics.checkNotNullParameter(map, "");
        this.AFKeystoreWrapper.values("deeplink_data", new JSONObject(map).toString());
    }
}
