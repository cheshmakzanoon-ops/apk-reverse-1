package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;

public final class AFf1eSDK implements AFe1eSDK {
    private final AFd1rSDK AFInAppEventParameterName;
    private final AFf1cSDK AFInAppEventType;
    private final Object AFKeystoreWrapper = new Object();
    private final AFe1zSDK AFLogger;

    private final AFf1dSDK f347d;

    private final AFe1dSDK f348e;
    private AFf1lSDK registerClient;
    private AFh1iSDK unregisterClient;
    public final AFf1gSDK valueOf;
    private final AFg1zSDK values;

    @Override
    public final void values(AFe1fSDK<?> aFe1fSDK) {
    }

    public AFf1eSDK(AFf1cSDK aFf1cSDK, AFd1rSDK aFd1rSDK, AFg1zSDK aFg1zSDK, AFf1gSDK aFf1gSDK, AFe1zSDK aFe1zSDK, AFf1dSDK aFf1dSDK, AFe1dSDK aFe1dSDK) {
        this.AFInAppEventType = aFf1cSDK;
        this.AFInAppEventParameterName = aFd1rSDK;
        this.values = aFg1zSDK;
        this.valueOf = aFf1gSDK;
        this.AFLogger = aFe1zSDK;
        this.f347d = aFf1dSDK;
        this.f348e = aFe1dSDK;
        aFe1dSDK.AFKeystoreWrapper.add(this);
    }

    public final void values(AFf1iSDK aFf1iSDK) {
        AFf1hSDK aFf1hSDK = new AFf1hSDK(this.AFInAppEventType, this.AFInAppEventParameterName, this.values, this.valueOf, this.AFLogger, this.f347d, "v1", aFf1iSDK);
        AFe1dSDK aFe1dSDK = this.f348e;
        aFe1dSDK.values.execute(aFe1dSDK.new RunnableC08534(aFf1hSDK));
    }

    public final AFh1iSDK AFInAppEventType() {
        AFh1iSDK aFh1iSDK;
        synchronized (this.AFKeystoreWrapper) {
            aFh1iSDK = this.unregisterClient;
            this.unregisterClient = null;
        }
        return aFh1iSDK;
    }

    private void values(AFf1lSDK aFf1lSDK, AFf1iSDK aFf1iSDK) {
        synchronized (this.AFKeystoreWrapper) {
            this.registerClient = aFf1lSDK;
        }
        if (aFf1iSDK != null) {
            aFf1iSDK.onRemoteConfigUpdateFinished(aFf1lSDK);
        }
    }

    @Override
    public final void AFKeystoreWrapper(AFe1fSDK<?> aFe1fSDK, AFe1cSDK aFe1cSDK) {
        if (aFe1fSDK instanceof AFf1hSDK) {
            AFf1hSDK aFf1hSDK = (AFf1hSDK) aFe1fSDK;
            AFf1lSDK aFf1lSDK = aFf1hSDK.AFLogger;
            if (aFf1lSDK == null) {
                AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "update RC returned null result, something went wrong!");
                aFf1lSDK = AFf1lSDK.FAILURE;
            }
            if (aFf1lSDK != AFf1lSDK.USE_CACHED) {
                AFh1iSDK aFh1iSDK = aFf1hSDK.unregisterClient;
                synchronized (this.AFKeystoreWrapper) {
                    this.unregisterClient = aFh1iSDK;
                }
            }
            values(aFf1lSDK, aFf1hSDK.f349d);
        }
    }

    @Override
    public final void AFKeystoreWrapper(AFe1fSDK<?> aFe1fSDK) {
        if (aFe1fSDK instanceof AFf1hSDK) {
            AFf1hSDK aFf1hSDK = (AFf1hSDK) aFe1fSDK;
            synchronized (this.AFKeystoreWrapper) {
                this.unregisterClient = null;
            }
            values(AFf1lSDK.FAILURE, aFf1hSDK.f349d);
        }
    }
}
