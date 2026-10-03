package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public final class AFi1kSDK {
    public final List<AFi1nSDK> AFInAppEventType = new ArrayList();
    public final AFd1nSDK AFKeystoreWrapper;

    public static void AFKeystoreWrapper() {
    }

    public AFi1kSDK(AFd1nSDK aFd1nSDK) {
        this.AFKeystoreWrapper = aFd1nSDK;
    }

    public final synchronized void AFKeystoreWrapper(AFi1nSDK aFi1nSDK) {
        this.AFInAppEventType.add(aFi1nSDK);
    }

    public final synchronized AFi1nSDK[] AFInAppEventType() {
        return (AFi1nSDK[]) this.AFInAppEventType.toArray(new AFi1nSDK[0]);
    }

    public final void values(final Runnable runnable) {
        AFKeystoreWrapper(new AFi1qSDK(this.AFKeystoreWrapper.AFInAppEventType(), this.AFKeystoreWrapper.values(), AFi1rSDK.FACEBOOK, runnable, new Runnable() {
            @Override
            public final void run() {
                this.f$0.valueOf(runnable);
            }
        }));
    }

    public final AFi1pSDK AFInAppEventParameterName(final Runnable runnable) {
        return new AFi1pSDK(new Runnable() {
            @Override
            public final void run() {
                this.f$0.AFInAppEventType(runnable);
            }
        }, this.AFKeystoreWrapper.values(), this.AFKeystoreWrapper.AFInAppEventType());
    }

    public void AFInAppEventType(final Runnable runnable) {
        AFi1bSDK.AFInAppEventType(this.AFKeystoreWrapper.valueOf(), new Runnable() {
            @Override
            public final void run() {
                this.f$0.AFKeystoreWrapper(runnable);
            }
        }, 0L, TimeUnit.MILLISECONDS);
    }

    public void AFKeystoreWrapper(Runnable runnable) {
        try {
            if (AFInAppEventParameterName(new AFh1wSDK())) {
                runnable.run();
            }
        } catch (Throwable th) {
            AFLogger.afErrorLog(th.getMessage(), th);
        }
    }

    public final boolean AFInAppEventParameterName(AFa1pSDK aFa1pSDK) {
        int iValueOf = this.AFKeystoreWrapper.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0);
        return (!this.AFKeystoreWrapper.AFKeystoreWrapper().valueOf(AppsFlyerProperties.NEW_REFERRER_SENT) && iValueOf == 1) || (iValueOf == 1 && !(aFa1pSDK instanceof AFh1wSDK));
    }

    public final Runnable AFInAppEventType(final AFi1pSDK aFi1pSDK, final Runnable runnable) {
        return new Runnable() {
            @Override
            public final void run() {
                this.f$0.AFInAppEventParameterName(aFi1pSDK, runnable);
            }
        };
    }

    public void AFInAppEventParameterName(AFi1pSDK aFi1pSDK, Runnable runnable) {
        AFd1xSDK aFd1xSDKAFKeystoreWrapper = this.AFKeystoreWrapper.AFKeystoreWrapper();
        int iValueOf = this.AFKeystoreWrapper.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0);
        boolean zValueOf = aFd1xSDKAFKeystoreWrapper.valueOf(AppsFlyerProperties.NEW_REFERRER_SENT);
        boolean z = aFi1pSDK.unregisterClient == AFi1nSDK.AFa1uSDK.NOT_STARTED;
        if (iValueOf == 1) {
            if (z || zValueOf) {
                runnable.run();
            }
        }
    }

    public final boolean AFInAppEventParameterName() {
        return this.AFKeystoreWrapper.AFInAppEventType().AFKeystoreWrapper("AF_PREINSTALL_DISABLED");
    }

    public void valueOf(Runnable runnable) {
        AFi1qSDK aFi1qSDK = new AFi1qSDK(this.AFKeystoreWrapper.AFInAppEventType(), this.AFKeystoreWrapper.values(), AFi1rSDK.INSTAGRAM, runnable, new Runnable() {
            @Override
            public final void run() {
                AFi1kSDK.AFKeystoreWrapper();
            }
        });
        AFKeystoreWrapper(aFi1qSDK);
        aFi1qSDK.values(this.AFKeystoreWrapper.mo786v().AFInAppEventParameterName);
    }
}
