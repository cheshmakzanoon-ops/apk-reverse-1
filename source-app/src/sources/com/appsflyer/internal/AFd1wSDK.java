package com.appsflyer.internal;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Bundle;
import com.appsflyer.AFLogger;
import java.util.concurrent.Executor;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import kotlin.jvm.internal.Intrinsics;

final class AFd1wSDK implements Application.ActivityLifecycleCallbacks {
    private final AFh1aSDK AFInAppEventParameterName;
    private final Executor AFInAppEventType;
    private final AFc1jSDK AFKeystoreWrapper;

    private boolean f330e;
    private boolean unregisterClient;
    private final ScheduledExecutorService valueOf;
    final AFd1ySDK.AFa1ySDK values;

    @Override
    public final void onActivityDestroyed(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "");
    }

    @Override
    public final void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
        Intrinsics.checkNotNullParameter(activity, "");
        Intrinsics.checkNotNullParameter(bundle, "");
    }

    @Override
    public final void onActivityStarted(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "");
    }

    @Override
    public final void onActivityStopped(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "");
    }

    public AFd1wSDK(Executor executor, ScheduledExecutorService scheduledExecutorService, AFc1jSDK aFc1jSDK, AFh1aSDK aFh1aSDK, AFd1ySDK.AFa1ySDK aFa1ySDK) {
        Intrinsics.checkNotNullParameter(executor, "");
        Intrinsics.checkNotNullParameter(scheduledExecutorService, "");
        Intrinsics.checkNotNullParameter(aFc1jSDK, "");
        Intrinsics.checkNotNullParameter(aFh1aSDK, "");
        Intrinsics.checkNotNullParameter(aFa1ySDK, "");
        this.AFInAppEventType = executor;
        this.valueOf = scheduledExecutorService;
        this.AFKeystoreWrapper = aFc1jSDK;
        this.AFInAppEventParameterName = aFh1aSDK;
        this.values = aFa1ySDK;
    }

    @Override
    public final void onActivityResumed(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "");
        final AFh1zSDK aFh1zSDK = new AFh1zSDK(activity, this.AFInAppEventParameterName);
        this.AFInAppEventType.execute(new Runnable() {
            @Override
            public final void run() {
                AFd1wSDK.valueOf(this.f$0, aFh1zSDK);
            }
        });
    }

    public static final void valueOf(AFd1wSDK aFd1wSDK, AFh1zSDK aFh1zSDK) {
        Intrinsics.checkNotNullParameter(aFd1wSDK, "");
        Intrinsics.checkNotNullParameter(aFh1zSDK, "");
        if (!aFd1wSDK.unregisterClient) {
            try {
                aFd1wSDK.values.valueOf(aFh1zSDK);
            } catch (Exception e) {
                AFLogger.afErrorLog("Listener thrown an exception: ", e, true);
            }
        }
        aFd1wSDK.f330e = false;
        aFd1wSDK.unregisterClient = true;
    }

    @Override
    public final void onActivityPaused(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "");
        this.AFInAppEventType.execute(new Runnable() {
            @Override
            public final void run() {
                AFd1wSDK.AFInAppEventType(this.f$0);
            }
        });
    }

    public static final void AFInAppEventType(final AFd1wSDK aFd1wSDK) {
        Intrinsics.checkNotNullParameter(aFd1wSDK, "");
        aFd1wSDK.f330e = true;
        try {
            ScheduledExecutorService scheduledExecutorService = aFd1wSDK.valueOf;
            Runnable runnable = new Runnable() {
                @Override
                public final void run() {
                    AFd1wSDK.valueOf(this.f$0);
                }
            };
            AFd1ySDK.Companion companion = AFd1ySDK.INSTANCE;
            scheduledExecutorService.schedule(runnable, AFd1ySDK.Companion.AFKeystoreWrapper(), TimeUnit.MILLISECONDS);
        } catch (Throwable th) {
            AFLogger.afErrorLog("Background task failed with a throwable: ", th);
        }
    }

    public static final void valueOf(AFd1wSDK aFd1wSDK) {
        Intrinsics.checkNotNullParameter(aFd1wSDK, "");
        if (aFd1wSDK.unregisterClient && aFd1wSDK.f330e) {
            aFd1wSDK.unregisterClient = false;
            try {
                aFd1wSDK.values.AFInAppEventParameterName();
            } catch (Exception e) {
                AFLogger.afErrorLog("Listener threw exception! ", e);
            }
        }
    }

    @Override
    public final void onActivityCreated(Activity activity, Bundle bundle) {
        Intrinsics.checkNotNullParameter(activity, "");
        AFc1jSDK aFc1jSDK = this.AFKeystoreWrapper;
        Intent intent = activity.getIntent();
        if (((intent == null || !"android.intent.action.VIEW".equals(intent.getAction())) ? null : intent.getData()) != null && intent != aFc1jSDK.AFKeystoreWrapper) {
            aFc1jSDK.AFKeystoreWrapper = intent;
        }
        this.AFInAppEventParameterName.values(activity);
    }
}
