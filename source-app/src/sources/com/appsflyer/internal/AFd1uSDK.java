package com.appsflyer.internal;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import java.util.concurrent.Executor;
import java.util.concurrent.ScheduledExecutorService;
import kotlin.jvm.internal.Intrinsics;

public final class AFd1uSDK implements AFd1ySDK {
    private final AFh1aSDK AFInAppEventParameterName;
    private AFd1wSDK AFInAppEventType;
    private final AFc1jSDK AFKeystoreWrapper;
    private final Executor valueOf;
    private final ScheduledExecutorService values;

    public AFd1uSDK(Executor executor, ScheduledExecutorService scheduledExecutorService, AFc1jSDK aFc1jSDK, AFh1aSDK aFh1aSDK) {
        Intrinsics.checkNotNullParameter(executor, "");
        Intrinsics.checkNotNullParameter(scheduledExecutorService, "");
        Intrinsics.checkNotNullParameter(aFc1jSDK, "");
        Intrinsics.checkNotNullParameter(aFh1aSDK, "");
        this.valueOf = executor;
        this.values = scheduledExecutorService;
        this.AFKeystoreWrapper = aFc1jSDK;
        this.AFInAppEventParameterName = aFh1aSDK;
    }

    @Override
    public final void AFKeystoreWrapper(Context context, AFd1ySDK.AFa1ySDK aFa1ySDK) {
        Intrinsics.checkNotNullParameter(context, "");
        Intrinsics.checkNotNullParameter(aFa1ySDK, "");
        Intrinsics.checkNotNullParameter(context, "");
        if (this.AFInAppEventType != null) {
            Context applicationContext = context.getApplicationContext();
            if (applicationContext == null) {
                throw new NullPointerException("null cannot be cast to non-null type android.app.Application");
            }
            ((Application) applicationContext).unregisterActivityLifecycleCallbacks(this.AFInAppEventType);
        }
        this.AFInAppEventType = null;
        AFd1wSDK aFd1wSDK = new AFd1wSDK(this.valueOf, this.values, this.AFKeystoreWrapper, this.AFInAppEventParameterName, aFa1ySDK);
        this.AFInAppEventType = aFd1wSDK;
        if (context instanceof Activity) {
            aFd1wSDK.onActivityResumed((Activity) context);
        }
        Application applicationValues = AFb1qSDK.values(context);
        if (applicationValues != null) {
            applicationValues.registerActivityLifecycleCallbacks(this.AFInAppEventType);
        }
    }

    @Override
    public final boolean valueOf() {
        return this.AFInAppEventType != null;
    }

    @Override
    public final void AFKeystoreWrapper() {
        AFd1ySDK.AFa1ySDK aFa1ySDK;
        AFd1wSDK aFd1wSDK = this.AFInAppEventType;
        if (aFd1wSDK == null || (aFa1ySDK = aFd1wSDK.values) == null) {
            return;
        }
        aFa1ySDK.AFInAppEventParameterName();
    }
}
