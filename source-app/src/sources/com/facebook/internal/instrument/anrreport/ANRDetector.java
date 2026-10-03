package com.facebook.internal.instrument.anrreport;

import android.app.ActivityManager;
import android.os.Looper;
import android.os.Process;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.FacebookSdk;
import com.facebook.internal.instrument.InstrumentData;
import com.facebook.internal.instrument.InstrumentUtility;
import com.facebook.internal.instrument.crashshield.CrashShieldHandler;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0012\u0010\r\u001a\u00020\u000e2\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010H\u0007J\b\u0010\u0011\u001a\u00020\u000eH\u0007R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\b\u001a\u0004\u0018\u00010\tX\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\n\u001a\n \f*\u0004\u0018\u00010\u000b0\u000bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"Lcom/facebook/internal/instrument/anrreport/ANRDetector;", "", "()V", "DETECTION_INTERVAL_IN_MS", "", "anrDetectorRunnable", "Ljava/lang/Runnable;", "myUid", "previousStackTrace", "", "scheduledExecutorService", "Ljava/util/concurrent/ScheduledExecutorService;", "kotlin.jvm.PlatformType", "checkProcessError", "", "am", "Landroid/app/ActivityManager;", "start", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ANRDetector {
    private static final int DETECTION_INTERVAL_IN_MS = 500;
    public static final ANRDetector INSTANCE = new ANRDetector();
    private static final int myUid = Process.myUid();
    private static final ScheduledExecutorService scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();
    private static String previousStackTrace = "";
    private static final Runnable anrDetectorRunnable = new Runnable() {
        @Override
        public final void run() {
            ANRDetector.m2529anrDetectorRunnable$lambda0();
        }
    };

    private ANRDetector() {
    }

    public static final void m2529anrDetectorRunnable$lambda0() {
        if (CrashShieldHandler.isObjectCrashing(ANRDetector.class)) {
            return;
        }
        try {
            FacebookSdk facebookSdk = FacebookSdk.INSTANCE;
            Object systemService = FacebookSdk.getApplicationContext().getSystemService("activity");
            if (systemService == null) {
                throw new NullPointerException("null cannot be cast to non-null type android.app.ActivityManager");
            }
            checkProcessError((ActivityManager) systemService);
        } catch (Exception unused) {
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ANRDetector.class);
        }
    }

    @JvmStatic
    public static final void checkProcessError(ActivityManager am) {
        if (CrashShieldHandler.isObjectCrashing(ANRDetector.class) || am == null) {
            return;
        }
        try {
            List<ActivityManager.ProcessErrorStateInfo> processesInErrorState = am.getProcessesInErrorState();
            if (processesInErrorState == null) {
                return;
            }
            for (ActivityManager.ProcessErrorStateInfo processErrorStateInfo : processesInErrorState) {
                if (processErrorStateInfo.condition == 2 && processErrorStateInfo.uid == myUid) {
                    Thread thread = Looper.getMainLooper().getThread();
                    Intrinsics.checkNotNullExpressionValue(thread, "getMainLooper().thread");
                    InstrumentUtility instrumentUtility = InstrumentUtility.INSTANCE;
                    String stackTrace = InstrumentUtility.getStackTrace(thread);
                    if (Intrinsics.areEqual(stackTrace, previousStackTrace)) {
                        continue;
                    } else {
                        InstrumentUtility instrumentUtility2 = InstrumentUtility.INSTANCE;
                        if (InstrumentUtility.isSDKRelatedThread(thread)) {
                            previousStackTrace = stackTrace;
                            InstrumentData.Builder builder = InstrumentData.Builder.INSTANCE;
                            InstrumentData.Builder.build(processErrorStateInfo.shortMsg, stackTrace).save();
                        }
                    }
                }
            }
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ANRDetector.class);
        }
    }

    @JvmStatic
    public static final void start() {
        if (CrashShieldHandler.isObjectCrashing(ANRDetector.class)) {
            return;
        }
        try {
            scheduledExecutorService.scheduleWithFixedDelay(anrDetectorRunnable, 0L, DETECTION_INTERVAL_IN_MS, TimeUnit.MILLISECONDS);
        } catch (Throwable th) {
            CrashShieldHandler.handleThrowable(th, ANRDetector.class);
        }
    }
}
