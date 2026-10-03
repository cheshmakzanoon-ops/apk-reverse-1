package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import kotlin.jvm.internal.Intrinsics;

public final class AFg1eSDK implements AFg1gSDK {
    private AFg1lSDK AFInAppEventParameterName;
    private AFg1dSDK AFInAppEventType;
    private final AFd1nSDK valueOf;
    private AFg1jSDK values;

    public AFg1eSDK(AFd1nSDK aFd1nSDK) {
        Intrinsics.checkNotNullParameter(aFd1nSDK, "");
        this.valueOf = aFd1nSDK;
    }

    @Override
    public final void AFKeystoreWrapper() {
        AFg1lSDK aFg1lSDK = this.AFInAppEventParameterName;
        if (aFg1lSDK != null) {
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1mSDK.v$default(aFLogger, AFg1hSDK.EXCEPTION_MANAGER, "Releasing Exception Manager Client", false, 4, null);
            aFLogger.unregisterClient(aFg1lSDK);
            this.AFInAppEventParameterName = null;
        }
    }

    @Override
    public final void values() {
        AFg1dSDK aFg1dSDK = this.AFInAppEventType;
        if (aFg1dSDK != null) {
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1mSDK.v$default(aFLogger, AFg1hSDK.RD, "Releasing Proxy Manager Client", false, 4, null);
            aFLogger.unregisterClient(aFg1dSDK);
            this.AFInAppEventType = null;
        }
    }

    @Override
    public final void AFInAppEventType() {
        AFg1jSDK aFg1jSDK = this.values;
        if (aFg1jSDK != null) {
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1mSDK.v$default(aFLogger, AFg1hSDK.RD, "Releasing Proxy Manager Client", false, 4, null);
            aFLogger.unregisterClient(aFg1jSDK);
            this.values = null;
        }
    }

    @Override
    public final void AFLogger() {
        AFLogger aFLogger = AFLogger.INSTANCE;
        AFg1mSDK[] aFg1mSDKArr = new AFg1mSDK[1];
        if (this.values == null) {
            this.values = new AFg1jSDK();
        }
        AFg1jSDK aFg1jSDK = this.values;
        Intrinsics.checkNotNull(aFg1jSDK);
        aFg1mSDKArr[0] = aFg1jSDK;
        aFLogger.registerClient(aFg1mSDKArr);
    }

    @Override
    public final void valueOf() {
        AFLogger aFLogger = AFLogger.INSTANCE;
        AFg1mSDK[] aFg1mSDKArr = new AFg1mSDK[1];
        if (this.AFInAppEventType == null) {
            this.AFInAppEventType = new AFg1dSDK(this.valueOf);
        }
        AFg1dSDK aFg1dSDK = this.AFInAppEventType;
        Intrinsics.checkNotNull(aFg1dSDK);
        aFg1mSDKArr[0] = aFg1dSDK;
        aFLogger.registerClient(aFg1mSDKArr);
    }

    @Override
    public final void AFInAppEventParameterName() {
        AFLogger aFLogger = AFLogger.INSTANCE;
        AFg1mSDK[] aFg1mSDKArr = new AFg1mSDK[1];
        if (this.AFInAppEventParameterName == null) {
            this.AFInAppEventParameterName = new AFg1lSDK(this.valueOf);
        }
        AFg1lSDK aFg1lSDK = this.AFInAppEventParameterName;
        Intrinsics.checkNotNull(aFg1lSDK);
        aFg1mSDKArr[0] = aFg1lSDK;
        aFLogger.registerClient(aFg1mSDKArr);
    }
}
