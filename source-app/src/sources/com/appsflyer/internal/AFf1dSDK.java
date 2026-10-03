package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFLogger;
import java.util.concurrent.TimeUnit;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\u0018\u0000 \u00142\u00020\u0001:\u0001\u0014B\u0017\u0012\u0006\u0010\u0010\u001a\u00020\b\u0012\u0006\u0010\u0011\u001a\u00020\u000e¢\u0006\u0004\b\u0012\u0010\u0013J\r\u0010\u0003\u001a\u00020\u0002¢\u0006\u0004\b\u0003\u0010\u0004J\r\u0010\u0006\u001a\u00020\u0005¢\u0006\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0003\u001a\u00020\b8\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\u0006\u0010\tR\u001b\u0010\f\u001a\u00020\u00058GX\u0087\u0084\u0002¢\u0006\f\n\u0004\b\n\u0010\u000b\u001a\u0004\b\n\u0010\u0007R\u001b\u0010\r\u001a\u00020\u00058GX\u0087\u0084\u0002¢\u0006\f\n\u0004\b\u0003\u0010\u000b\u001a\u0004\b\f\u0010\u0007R\u0014\u0010\n\u001a\u00020\u000e8\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\f\u0010\u000f"}, d2 = {"Lcom/appsflyer/internal/AFf1dSDK;", "", "", "valueOf", "()J", "", "values", "()Z", "Lcom/appsflyer/internal/AFd1rSDK;", "Lcom/appsflyer/internal/AFd1rSDK;", "AFInAppEventType", "Lkotlin/Lazy;", "AFInAppEventParameterName", "AFKeystoreWrapper", "Lcom/appsflyer/internal/AFf1gSDK;", "Lcom/appsflyer/internal/AFf1gSDK;", "p0", "p1", "<init>", "(Lcom/appsflyer/internal/AFd1rSDK;Lcom/appsflyer/internal/AFf1gSDK;)V", "AFa1zSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFf1dSDK {

    private final AFf1gSDK AFInAppEventType;

    private final Lazy AFInAppEventParameterName;

    private final Lazy AFKeystoreWrapper;

    private final AFd1rSDK valueOf;
    private static final long AFKeystoreWrapper = TimeUnit.HOURS.toSeconds(24);

    public AFf1dSDK(AFd1rSDK aFd1rSDK, AFf1gSDK aFf1gSDK) {
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        Intrinsics.checkNotNullParameter(aFf1gSDK, "");
        this.valueOf = aFd1rSDK;
        this.AFInAppEventType = aFf1gSDK;
        this.AFInAppEventParameterName = LazyKt.lazy(new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean invoke() {
                return Boolean.valueOf(Boolean.parseBoolean(AFf1dSDK.this.valueOf.values("com.appsflyer.rc.sandbox")));
            }
        });
        this.AFKeystoreWrapper = LazyKt.lazy(new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean invoke() {
                return Boolean.valueOf(Boolean.parseBoolean(AFf1dSDK.this.valueOf.values("com.appsflyer.rc.staging")));
            }
        });
    }

    public final boolean AFInAppEventType() {
        return ((Boolean) this.AFInAppEventParameterName.getValue()).booleanValue();
    }

    public final boolean AFInAppEventParameterName() {
        return ((Boolean) this.AFKeystoreWrapper.getValue()).booleanValue();
    }

    public final long valueOf() {
        Object objValueOf;
        String strValues = this.valueOf.values("com.appsflyer.rc.cache.max-age-fallback");
        if (strValues != null) {
            try {
                Result.Companion companion = Result.Companion;
                AFf1dSDK aFf1dSDK = this;
                objValueOf = Result.constructor-impl(Long.valueOf(Long.parseLong(strValues)));
            } catch (Throwable th) {
                Result.Companion companion2 = Result.Companion;
                objValueOf = Result.constructor-impl(ResultKt.createFailure(th));
            }
            Throwable th2 = Result.exceptionOrNull-impl(objValueOf);
            if (th2 != null) {
                StringBuilder sb = new StringBuilder("Can't read maxAgeFallback from Manifest: ");
                sb.append(th2.getMessage());
                AFLogger.afErrorLog(sb.toString(), th2);
                objValueOf = Long.valueOf(AFKeystoreWrapper);
            }
            return ((Number) objValueOf).longValue();
        }
        return AFKeystoreWrapper;
    }

    public final boolean values() {
        AFh1jSDK aFh1jSDK;
        AFh1nSDK aFh1nSDK = this.AFInAppEventType.AFInAppEventType;
        if (aFh1nSDK == null) {
            AFg1mSDK.i$default(AFLogger.INSTANCE, AFg1hSDK.REMOTE_CONTROL, "active config is missing - fetching from CDN", false, 4, null);
            return true;
        }
        AFh1mSDK aFh1mSDK = aFh1nSDK.AFInAppEventType;
        return ((aFh1mSDK == null || (aFh1jSDK = aFh1mSDK.AFInAppEventType) == null) ? false : aFh1jSDK.AFInAppEventParameterName()) || System.currentTimeMillis() - this.AFInAppEventType.valueOf > TimeUnit.SECONDS.toMillis(this.AFInAppEventType.AFKeystoreWrapper);
    }
}
