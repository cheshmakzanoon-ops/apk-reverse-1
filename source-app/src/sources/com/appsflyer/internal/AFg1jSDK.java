package com.appsflyer.internal;

import android.util.Log;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u000b\u0018\u0000  2\u00020\u0001:\u0001 B\u0007¢\u0006\u0004\b\u001e\u0010\u001fJ'\u0010\t\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u0006H\u0016¢\u0006\u0004\b\t\u0010\nJG\u0010\u0010\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010\u000f\u001a\u00020\u0006H\u0016¢\u0006\u0004\b\u0010\u0010\u0011J\u001f\u0010\u0012\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0004H\u0016¢\u0006\u0004\b\u0012\u0010\u0013J'\u0010\u0014\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u0006H\u0016¢\u0006\u0004\b\u0014\u0010\nJ1\u0010\u0016\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00152\u0006\u0010\u0005\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u00042\b\u0010\f\u001a\u0004\u0018\u00010\u000bH\u0002¢\u0006\u0004\b\u0016\u0010\u0017J\u0017\u0010\u0016\u001a\u00020\u00062\u0006\u0010\u0003\u001a\u00020\u0015H\u0002¢\u0006\u0004\b\u0016\u0010\u0018J'\u0010\u0019\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u0006H\u0016¢\u0006\u0004\b\u0019\u0010\nJ'\u0010\u001a\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u0006H\u0016¢\u0006\u0004\b\u001a\u0010\nR\u0014\u0010\u001d\u001a\u00020\u00068WX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u001c"}, d2 = {"Lcom/appsflyer/internal/AFg1jSDK;", "Lcom/appsflyer/internal/AFg1mSDK;", "Lcom/appsflyer/internal/AFg1hSDK;", "p0", "", "p1", "", "p2", "", "d", "(Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;Z)V", "", "p3", "p4", "p5", "p6", "e", "(Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;Ljava/lang/Throwable;ZZZZ)V", "force", "(Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;)V", "i", "Lcom/appsflyer/AFLogger$LogLevel;", "AFInAppEventParameterName", "(Lcom/appsflyer/AFLogger$LogLevel;Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;Ljava/lang/Throwable;)V", "(Lcom/appsflyer/AFLogger$LogLevel;)Z", "v", "w", "getShouldExtendMsg", "()Z", "values", "<init>", "()V", "AFa1vSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFg1jSDK extends AFg1mSDK {

    public class AFa1ySDK {
        public static final int[] AFInAppEventType;

        static {
            int[] iArr = new int[AFLogger.LogLevel.values().length];
            iArr[AFLogger.LogLevel.DEBUG.ordinal()] = 1;
            iArr[AFLogger.LogLevel.INFO.ordinal()] = 2;
            iArr[AFLogger.LogLevel.WARNING.ordinal()] = 3;
            iArr[AFLogger.LogLevel.VERBOSE.ordinal()] = 4;
            iArr[AFLogger.LogLevel.ERROR.ordinal()] = 5;
            iArr[AFLogger.LogLevel.NONE.ordinal()] = 6;
            AFInAppEventType = iArr;
        }
    }

    @Override
    public final boolean getShouldExtendMsg() {
        return AFLogger.LogLevel.VERBOSE.getLevel() <= AppsFlyerProperties.getInstance().getLogLevel();
    }

    @Override
    public final void mo759d(AFg1hSDK p0, String p1, boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        AFInAppEventParameterName(AFLogger.LogLevel.DEBUG, p0, p1, null);
    }

    @Override
    public final void mo760e(AFg1hSDK p0, String p1, Throwable p2, boolean p3, boolean p4, boolean p5, boolean p6) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        Intrinsics.checkNotNullParameter(p2, "");
        if (p4) {
            AFInAppEventParameterName(AFLogger.LogLevel.ERROR, p0, p1, p2);
        } else if (p3) {
            AFInAppEventParameterName(AFLogger.LogLevel.DEBUG, p0, p1, null);
        }
    }

    @Override
    public final void mo761i(AFg1hSDK p0, String p1, boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        AFInAppEventParameterName(AFLogger.LogLevel.INFO, p0, p1, null);
    }

    @Override
    public final void mo763w(AFg1hSDK p0, String p1, boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        AFInAppEventParameterName(AFLogger.LogLevel.WARNING, p0, p1, null);
    }

    @Override
    public final void mo762v(AFg1hSDK p0, String p1, boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        AFInAppEventParameterName(AFLogger.LogLevel.VERBOSE, p0, p1, null);
    }

    @Override
    public final void force(AFg1hSDK p0, String p1) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        if (AppsFlyerProperties.getInstance().isLogsDisabledCompletely()) {
            return;
        }
        Log.d("AppsFlyer_6.13.0", withTag$SDK_prodRelease(p1, p0));
    }

    private final void AFInAppEventParameterName(AFLogger.LogLevel p0, AFg1hSDK p1, String p2, Throwable p3) {
        if (AFInAppEventParameterName(p0)) {
            String strAFInAppEventType = AFInAppEventType(p2, p1);
            int i = AFa1ySDK.AFInAppEventType[p0.ordinal()];
            if (i == 1) {
                Log.d("AppsFlyer_6.13.0", strAFInAppEventType);
                return;
            }
            if (i == 2) {
                Log.i("AppsFlyer_6.13.0", strAFInAppEventType);
                return;
            }
            if (i == 3) {
                Log.w("AppsFlyer_6.13.0", strAFInAppEventType);
            } else if (i == 4) {
                Log.v("AppsFlyer_6.13.0", strAFInAppEventType);
            } else {
                if (i != 5) {
                    return;
                }
                Log.e("AppsFlyer_6.13.0", strAFInAppEventType, p3);
            }
        }
    }

    private static boolean AFInAppEventParameterName(AFLogger.LogLevel p0) {
        return p0.getLevel() <= AppsFlyerProperties.getInstance().getLogLevel();
    }
}
