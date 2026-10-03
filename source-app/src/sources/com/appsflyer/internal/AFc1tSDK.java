package com.appsflyer.internal;

import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import java.util.Map;
import kotlin.jvm.internal.Intrinsics;

public final class AFc1tSDK implements Runnable {
    private final AFd1nSDK AFInAppEventType;
    private final Map<String, Object> AFKeystoreWrapper;
    private final AFa1pSDK valueOf;

    public AFc1tSDK(AFd1nSDK aFd1nSDK, AFa1pSDK aFa1pSDK, Map<String, ? extends Object> map) {
        Intrinsics.checkNotNullParameter(aFd1nSDK, "");
        Intrinsics.checkNotNullParameter(aFa1pSDK, "");
        this.AFInAppEventType = aFd1nSDK;
        this.valueOf = aFa1pSDK;
        this.AFKeystoreWrapper = map;
    }

    @Override
    public final void run() {
        AFf1kSDK aFf1pSDK;
        if (this.valueOf.valueOf()) {
            AFf1kSDK aFf1kSDK = new AFf1kSDK(this.valueOf, this.AFInAppEventType);
            aFf1kSDK.force = this.AFKeystoreWrapper;
            aFf1pSDK = aFf1kSDK;
        } else {
            aFf1pSDK = new AFf1pSDK(this.valueOf, this.AFInAppEventType);
        }
        AFe1dSDK aFe1dSDKMo787w = this.AFInAppEventType.mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1pSDK));
    }
}
