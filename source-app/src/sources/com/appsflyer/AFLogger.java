package com.appsflyer;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.location.LocationRequestCompat;
import com.appsflyer.internal.AFg1hSDK;
import com.appsflyer.internal.AFg1mSDK;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u0011\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010#\n\u0002\b\u0005\bÆ\u0002\u0018\u00002\u00020\u0001:\u00011B\t\b\u0002¢\u0006\u0004\b/\u00100J\u0017\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0005\u0010\u0006J\u001f\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u0005\u0010\tJ7\u0010\u000e\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\u00072\u0006\u0010\f\u001a\u00020\u00072\u0006\u0010\r\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u000e\u0010\u000fJ#\u0010\u000e\u001a\u00020\u00042\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\b\u001a\u0004\u0018\u00010\nH\u0007¢\u0006\u0004\b\u000e\u0010\u0010J+\u0010\u000e\u001a\u00020\u00042\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\b\u001a\u0004\u0018\u00010\n2\u0006\u0010\u000b\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u000e\u0010\u0011J3\u0010\u000e\u001a\u00020\u00042\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\b\u001a\u0004\u0018\u00010\n2\u0006\u0010\u000b\u001a\u00020\u00072\u0006\u0010\f\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u000e\u0010\u0012J#\u0010\u0013\u001a\u00020\u00042\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\b\u001a\u0004\u0018\u00010\nH\u0007¢\u0006\u0004\b\u0013\u0010\u0010J+\u0010\u0013\u001a\u00020\u00042\b\u0010\u0003\u001a\u0004\u0018\u00010\u00022\b\u0010\b\u001a\u0004\u0018\u00010\n2\u0006\u0010\u000b\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u0013\u0010\u0011J\u0017\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0014\u0010\u0006J\u001f\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u0014\u0010\tJ\u0017\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0015\u0010\u0006J\u0017\u0010\u0016\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0016\u0010\u0006J\u0017\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0017\u0010\u0006J\u0017\u0010\u0018\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0018\u0010\u0006J\u001f\u0010\u0018\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00022\u0006\u0010\b\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\u0018\u0010\tJ'\u0010\u001a\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00192\u0006\u0010\b\u001a\u00020\u00022\u0006\u0010\u000b\u001a\u00020\u0007H\u0016¢\u0006\u0004\b\u001a\u0010\u001bJG\u0010\u001e\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00192\u0006\u0010\b\u001a\u00020\u00022\u0006\u0010\u000b\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\u00072\u0006\u0010\r\u001a\u00020\u00072\u0006\u0010\u001c\u001a\u00020\u00072\u0006\u0010\u001d\u001a\u00020\u0007H\u0016¢\u0006\u0004\b\u001e\u0010\u001fJ\u001f\u0010 \u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00192\u0006\u0010\b\u001a\u00020\u0002H\u0016¢\u0006\u0004\b \u0010!J'\u0010\"\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00192\u0006\u0010\b\u001a\u00020\u00022\u0006\u0010\u000b\u001a\u00020\u0007H\u0016¢\u0006\u0004\b\"\u0010\u001bJ!\u0010$\u001a\u00020\u00042\u0012\u0010\u0003\u001a\n\u0012\u0006\b\u0001\u0012\u00020\u00010#\"\u00020\u0001¢\u0006\u0004\b$\u0010%J!\u0010&\u001a\u00020\u00042\u0012\u0010\u0003\u001a\n\u0012\u0006\b\u0001\u0012\u00020\u00010#\"\u00020\u0001¢\u0006\u0004\b&\u0010%J'\u0010'\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00192\u0006\u0010\b\u001a\u00020\u00022\u0006\u0010\u000b\u001a\u00020\u0007H\u0016¢\u0006\u0004\b'\u0010\u001bJ'\u0010(\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00192\u0006\u0010\b\u001a\u00020\u00022\u0006\u0010\u000b\u001a\u00020\u0007H\u0016¢\u0006\u0004\b(\u0010\u001bR\u0017\u0010*\u001a\u0006*\u00020)0)X\u0083\u0080\u0002¢\u0006\u0006\n\u0004\b*\u0010+R\u0019\u0010.\u001a\b\u0012\u0004\u0012\u00020\u00010,X\u0083\u0080\u0002¢\u0006\u0006\n\u0004\b-\u0010+"}, d2 = {"Lcom/appsflyer/AFLogger;", "Lcom/appsflyer/internal/AFg1mSDK;", "", "p0", "", "afDebugLog", "(Ljava/lang/String;)V", "", "p1", "(Ljava/lang/String;Z)V", "", "p2", "p3", "p4", "afErrorLog", "(Ljava/lang/String;Ljava/lang/Throwable;ZZZ)V", "(Ljava/lang/String;Ljava/lang/Throwable;)V", "(Ljava/lang/String;Ljava/lang/Throwable;Z)V", "(Ljava/lang/String;Ljava/lang/Throwable;ZZ)V", "afErrorLogForExcManagerOnly", "afInfoLog", "afLogForce", "afRDLog", "afVerboseLog", "afWarnLog", "Lcom/appsflyer/internal/AFg1hSDK;", "d", "(Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;Z)V", "p5", "p6", "e", "(Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;Ljava/lang/Throwable;ZZZZ)V", "force", "(Lcom/appsflyer/internal/AFg1hSDK;Ljava/lang/String;)V", "i", "", "registerClient", "([Lcom/appsflyer/internal/AFg1mSDK;)V", "unregisterClient", "v", "w", "Ljava/util/concurrent/ExecutorService;", "valueOf", "Lkotlin/Lazy;", "", "AFKeystoreWrapper", "values", "<init>", "()V", "LogLevel"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFLogger extends AFg1mSDK {
    public static final AFLogger INSTANCE = new AFLogger();

    private static final Lazy values = LazyKt.lazy(new Function0<Set<AFg1mSDK>>() {
        public final Set<AFg1mSDK> invoke() {
            return Collections.synchronizedSet(new LinkedHashSet());
        }
    });
    private static final Lazy valueOf = LazyKt.lazy(new Function0<ExecutorService>() {
        public final ExecutorService invoke() {
            return Executors.newSingleThreadExecutor();
        }
    });

    private AFLogger() {
    }

    public final void registerClient(final AFg1mSDK... p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        ((ExecutorService) valueOf.getValue()).execute(new Runnable() {
            @Override
            public final void run() {
                AFLogger.AFInAppEventParameterName(p0);
            }
        });
    }

    public final void unregisterClient(final AFg1mSDK... p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        ((ExecutorService) valueOf.getValue()).execute(new Runnable() {
            @Override
            public final void run() {
                AFLogger.valueOf(p0);
            }
        });
    }

    @Override
    public final void mo759d(final AFg1hSDK p0, final String p1, final boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        ((ExecutorService) valueOf.getValue()).execute(new AFLogger$$ExternalSyntheticLambda1(new Function1<AFg1mSDK, Unit>() {
            {
                super(1);
            }

            public final void AFInAppEventParameterName(AFg1mSDK aFg1mSDK) {
                Intrinsics.checkNotNullParameter(aFg1mSDK, "");
                aFg1mSDK.mo759d(p0, p1, p2);
            }

            public final Object invoke(Object obj) {
                AFInAppEventParameterName((AFg1mSDK) obj);
                return Unit.INSTANCE;
            }
        }));
    }

    @Override
    public final void mo760e(final AFg1hSDK p0, final String p1, final Throwable p2, final boolean p3, final boolean p4, final boolean p5, final boolean p6) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        Intrinsics.checkNotNullParameter(p2, "");
        ((ExecutorService) valueOf.getValue()).execute(new AFLogger$$ExternalSyntheticLambda1(new Function1<AFg1mSDK, Unit>() {
            {
                super(1);
            }

            public final Object invoke(Object obj) {
                AFKeystoreWrapper((AFg1mSDK) obj);
                return Unit.INSTANCE;
            }

            public final void AFKeystoreWrapper(AFg1mSDK aFg1mSDK) {
                Intrinsics.checkNotNullParameter(aFg1mSDK, "");
                aFg1mSDK.mo760e(p0, p1, p2, p3, p4, p5, p6);
            }
        }));
    }

    @Override
    public final void mo761i(final AFg1hSDK p0, final String p1, final boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        ((ExecutorService) valueOf.getValue()).execute(new AFLogger$$ExternalSyntheticLambda1(new Function1<AFg1mSDK, Unit>() {
            {
                super(1);
            }

            public final void AFKeystoreWrapper(AFg1mSDK aFg1mSDK) {
                Intrinsics.checkNotNullParameter(aFg1mSDK, "");
                aFg1mSDK.mo761i(p0, p1, p2);
            }

            public final Object invoke(Object obj) {
                AFKeystoreWrapper((AFg1mSDK) obj);
                return Unit.INSTANCE;
            }
        }));
    }

    @Override
    public final void mo763w(final AFg1hSDK p0, final String p1, final boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        ((ExecutorService) valueOf.getValue()).execute(new AFLogger$$ExternalSyntheticLambda1(new Function1<AFg1mSDK, Unit>() {
            {
                super(1);
            }

            public final void AFInAppEventParameterName(AFg1mSDK aFg1mSDK) {
                Intrinsics.checkNotNullParameter(aFg1mSDK, "");
                aFg1mSDK.mo763w(p0, p1, p2);
            }

            public final Object invoke(Object obj) {
                AFInAppEventParameterName((AFg1mSDK) obj);
                return Unit.INSTANCE;
            }
        }));
    }

    @Override
    public final void mo762v(final AFg1hSDK p0, final String p1, final boolean p2) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        ((ExecutorService) valueOf.getValue()).execute(new AFLogger$$ExternalSyntheticLambda1(new Function1<AFg1mSDK, Unit>() {
            {
                super(1);
            }

            public final void AFInAppEventType(AFg1mSDK aFg1mSDK) {
                Intrinsics.checkNotNullParameter(aFg1mSDK, "");
                aFg1mSDK.mo762v(p0, p1, p2);
            }

            public final Object invoke(Object obj) {
                AFInAppEventType((AFg1mSDK) obj);
                return Unit.INSTANCE;
            }
        }));
    }

    @Override
    public final void force(final AFg1hSDK p0, final String p1) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        ((ExecutorService) valueOf.getValue()).execute(new AFLogger$$ExternalSyntheticLambda1(new Function1<AFg1mSDK, Unit>() {
            {
                super(1);
            }

            public final void AFInAppEventParameterName(AFg1mSDK aFg1mSDK) {
                Intrinsics.checkNotNullParameter(aFg1mSDK, "");
                aFg1mSDK.force(p0, p1);
            }

            public final Object invoke(Object obj) {
                AFInAppEventParameterName((AFg1mSDK) obj);
                return Unit.INSTANCE;
            }
        }));
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.i()", imports = {}))
    @JvmStatic
    public static final void afInfoLog(String p0, boolean p1) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo761i(AFg1hSDK.OTHER, p0, p1);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.d()", imports = {}))
    @JvmStatic
    public static final void afDebugLog(String p0, boolean p1) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo759d(AFg1hSDK.OTHER, p0, p1);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.e()", imports = {}))
    @JvmStatic
    public static final void afErrorLog(String p0, Throwable p1, boolean p2, boolean p3, boolean p4) {
        Intrinsics.checkNotNullParameter(p0, "");
        Intrinsics.checkNotNullParameter(p1, "");
        AFg1mSDK.e$default(INSTANCE, AFg1hSDK.OTHER, p0, p1, p2, p3, p4, false, 64, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.w()", imports = {}))
    @JvmStatic
    public static final void afWarnLog(String p0, boolean p1) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo763w(AFg1hSDK.OTHER, p0, p1);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.v()", imports = {}))
    @JvmStatic
    public static final void afVerboseLog(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo762v(AFg1hSDK.OTHER, p0, false);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.v()", imports = {}))
    @JvmStatic
    public static final void afRDLog(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo762v(AFg1hSDK.OTHER, p0, true);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.force()", imports = {}))
    @JvmStatic
    public static final void afLogForce(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.force(AFg1hSDK.OTHER, p0);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.d()", imports = {}))
    @JvmStatic
    public static final void afDebugLog(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo759d(AFg1hSDK.OTHER, p0, true);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.i()", imports = {}))
    @JvmStatic
    public static final void afInfoLog(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        INSTANCE.mo761i(AFg1hSDK.OTHER, p0, true);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.e()", imports = {}))
    @JvmStatic
    public static final void afErrorLog(String p0, Throwable p1) {
        AFLogger aFLogger = INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.OTHER;
        String str = p0;
        if (str == null || StringsKt.isBlank(str)) {
            p0 = "null";
        }
        String str2 = p0;
        if (p1 == null) {
            p1 = new NullPointerException("Invoked with null Throwable");
        }
        AFg1mSDK.e$default(aFLogger, aFg1hSDK, str2, p1, false, false, false, false, 120, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.e()", imports = {}))
    @JvmStatic
    public static final void afErrorLogForExcManagerOnly(String p0, Throwable p1) {
        AFLogger aFLogger = INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.OTHER;
        String str = p0;
        if (str == null || StringsKt.isBlank(str)) {
            p0 = "null";
        }
        String str2 = p0;
        if (p1 == null) {
            p1 = new NullPointerException("Invoked with null Throwable");
        }
        AFg1mSDK.e$default(aFLogger, aFg1hSDK, str2, p1, false, false, true, false, 64, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.e()", imports = {}))
    @JvmStatic
    public static final void afErrorLogForExcManagerOnly(String p0, Throwable p1, boolean p2) {
        AFLogger aFLogger = INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.OTHER;
        String str = p0;
        if (str == null || StringsKt.isBlank(str)) {
            p0 = "null";
        }
        String str2 = p0;
        if (p1 == null) {
            p1 = new NullPointerException("Invoked with null Throwable");
        }
        AFg1mSDK.e$default(aFLogger, aFg1hSDK, str2, p1, false, false, !p2, false, 64, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.e()", imports = {}))
    @JvmStatic
    public static final void afErrorLog(String p0, Throwable p1, boolean p2) {
        AFLogger aFLogger = INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.OTHER;
        String str = p0;
        if (str == null || StringsKt.isBlank(str)) {
            p0 = "null";
        }
        String str2 = p0;
        if (p1 == null) {
            p1 = new NullPointerException("Invoked with null Throwable");
        }
        AFg1mSDK.e$default(aFLogger, aFg1hSDK, str2, p1, false, p2, false, false, LocationRequestCompat.QUALITY_LOW_POWER, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.e()", imports = {}))
    @JvmStatic
    public static final void afErrorLog(String p0, Throwable p1, boolean p2, boolean p3) {
        AFLogger aFLogger = INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.OTHER;
        String str = p0;
        if (str == null || StringsKt.isBlank(str)) {
            p0 = "null";
        }
        String str2 = p0;
        if (p1 == null) {
            p1 = new NullPointerException("Invoked with null Throwable");
        }
        AFg1mSDK.e$default(aFLogger, aFg1hSDK, str2, p1, false, p2, p3, false, 72, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Deprecated since v6.13.0", replaceWith = @ReplaceWith(expression = "AFLogger.w()", imports = {}))
    @JvmStatic
    public static final void afWarnLog(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        AFg1mSDK.w$default(INSTANCE, AFg1hSDK.OTHER, p0, false, 4, null);
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\u0010\b\n\u0002\b\u000e\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0011\b\u0002\u0012\u0006\u0010\b\u001a\u00020\u0002¢\u0006\u0004\b\t\u0010\nR\u0017\u0010\u0007\u001a\u00020\u00028\u0007¢\u0006\f\n\u0004\b\u0003\u0010\u0004\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u000bj\u0002\b\fj\u0002\b\rj\u0002\b\u000ej\u0002\b\u000fj\u0002\b\u0010"}, d2 = {"Lcom/appsflyer/AFLogger$LogLevel;", "", "", "AFInAppEventParameterName", "I", "getLevel", "()I", "level", "p0", "<init>", "(Ljava/lang/String;II)V", "NONE", "ERROR", "WARNING", "INFO", "DEBUG", "VERBOSE"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public enum LogLevel {
        NONE(0),
        ERROR(1),
        WARNING(2),
        INFO(3),
        DEBUG(4),
        VERBOSE(5);


        private final int level;

        LogLevel(int i) {
            this.level = i;
        }

        public final int getLevel() {
            return this.level;
        }
    }

    public static final void AFInAppEventParameterName(AFg1mSDK[] aFg1mSDKArr) {
        Intrinsics.checkNotNullParameter(aFg1mSDKArr, "");
        Lazy lazy = values;
        Object value = lazy.getValue();
        Intrinsics.checkNotNullExpressionValue(value, "");
        synchronized (((Set) value)) {
            Object value2 = lazy.getValue();
            Intrinsics.checkNotNullExpressionValue(value2, "");
            CollectionsKt.addAll((Set) value2, aFg1mSDKArr);
            Unit unit = Unit.INSTANCE;
        }
    }

    public static final void valueOf(AFg1mSDK[] aFg1mSDKArr) {
        Intrinsics.checkNotNullParameter(aFg1mSDKArr, "");
        Lazy lazy = values;
        Object value = lazy.getValue();
        Intrinsics.checkNotNullExpressionValue(value, "");
        synchronized (((Set) value)) {
            Object value2 = lazy.getValue();
            Intrinsics.checkNotNullExpressionValue(value2, "");
            ((Set) value2).removeAll(ArraysKt.toSet(aFg1mSDKArr));
            Unit unit = Unit.INSTANCE;
        }
    }

    public static final void AFInAppEventType(Function1 function1) {
        Intrinsics.checkNotNullParameter(function1, "");
        Lazy lazy = values;
        Object value = lazy.getValue();
        Intrinsics.checkNotNullExpressionValue(value, "");
        synchronized (((Set) value)) {
            Object value2 = lazy.getValue();
            Intrinsics.checkNotNullExpressionValue(value2, "");
            Iterator it = ((Set) value2).iterator();
            while (it.hasNext()) {
                function1.invoke((AFg1mSDK) it.next());
            }
            Unit unit = Unit.INSTANCE;
        }
    }
}
