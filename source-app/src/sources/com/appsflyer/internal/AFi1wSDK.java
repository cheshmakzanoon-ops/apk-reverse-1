package com.appsflyer.internal;

import java.util.Map;

public abstract class AFi1wSDK extends AFi1nSDK {
    AFi1wSDK(String str, String str2, Runnable runnable) {
        super(str, str2, runnable);
    }

    final void values(AFd1xSDK aFd1xSDK, AFd1zSDK<Map<String, Object>> aFd1zSDK) {
        AFb1vSDK.valueOf();
        if (AFb1vSDK.AFInAppEventType(aFd1xSDK, false) > 0 || !aFd1zSDK.AFInAppEventParameterName()) {
            return;
        }
        aFd1zSDK.AFInAppEventParameterName.values().execute(aFd1zSDK.AFInAppEventType);
        this.f408d = System.currentTimeMillis();
        this.unregisterClient = AFi1nSDK.AFa1uSDK.STARTED;
        addObserver(new AFi1nSDK.C08753());
    }
}
