package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B+\b\u0002\u0012\u0014\u0010\u0003\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u000b\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u000e¢\u0006\u0004\b\u0011\u0010\u0012J\u0015\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002¢\u0006\u0004\b\u0005\u0010\u0006J\u001f\u0010\t\u001a\u00020\b2\u0006\u0010\u0003\u001a\u00020\u00022\b\u0010\u0007\u001a\u0004\u0018\u00010\u0001¢\u0006\u0004\b\t\u0010\nR\"\u0010\f\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u000b8\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\f\u0010\rR\u0016\u0010\u0010\u001a\u0004\u0018\u00010\u000e8\u0002X\u0083\u0004¢\u0006\u0006\n\u0004\b\u0005\u0010\u000f"}, d2 = {"Lcom/appsflyer/internal/AFc1oSDK;", "", "", "p0", "", "AFInAppEventParameterName", "(Ljava/lang/String;)Z", "p1", "", "AFInAppEventType", "(Ljava/lang/String;Ljava/lang/Object;)V", "", "AFKeystoreWrapper", "Ljava/util/Map;", "Lcom/appsflyer/internal/AFc1kSDK;", "Lcom/appsflyer/internal/AFc1kSDK;", "values", "<init>", "(Ljava/util/Map;Lcom/appsflyer/internal/AFc1kSDK;)V", "AFa1tSDK"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFc1oSDK {

    public static final Companion INSTANCE = new Companion(null);

    public final AFc1kSDK values;
    public final Map<String, Object> AFKeystoreWrapper;

    public AFc1oSDK(Map map, AFc1kSDK aFc1kSDK, DefaultConstructorMarker defaultConstructorMarker) {
        this(map, aFc1kSDK);
    }

    @JvmStatic
    public static final AFc1oSDK valueOf(AFa1pSDK aFa1pSDK) {
        return Companion.AFInAppEventType(aFa1pSDK);
    }

    @JvmStatic
    public static final AFc1oSDK values(AFc1kSDK aFc1kSDK) {
        return Companion.values(aFc1kSDK);
    }

    private AFc1oSDK(Map<String, Object> map, AFc1kSDK aFc1kSDK) {
        this.AFKeystoreWrapper = map;
        this.values = aFc1kSDK;
    }

    AFc1oSDK(Map map, AFc1kSDK aFc1kSDK, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(map, (i & 2) != 0 ? null : aFc1kSDK);
    }

    @Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\n\u0010\u000bJ\u0017\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0005\u0010\u0006J\u0017\u0010\b\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0007H\u0007¢\u0006\u0004\b\b\u0010\t"}, d2 = {"Lcom/appsflyer/internal/AFc1oSDK$AFa1tSDK;", "", "Lcom/appsflyer/internal/AFa1pSDK;", "p0", "Lcom/appsflyer/internal/AFc1oSDK;", "AFInAppEventType", "(Lcom/appsflyer/internal/AFa1pSDK;)Lcom/appsflyer/internal/AFc1oSDK;", "Lcom/appsflyer/internal/AFc1kSDK;", "values", "(Lcom/appsflyer/internal/AFc1kSDK;)Lcom/appsflyer/internal/AFc1oSDK;", "<init>", "()V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public static AFc1oSDK AFInAppEventType(AFa1pSDK p0) {
            Intrinsics.checkNotNullParameter(p0, "");
            Map<String, Object> mapAFInAppEventType = p0.AFInAppEventType();
            Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
            AFc1kSDK aFc1kSDK = null;
            return new AFc1oSDK(mapAFInAppEventType, aFc1kSDK, 2, aFc1kSDK);
        }

        @JvmStatic
        public static AFc1oSDK values(AFc1kSDK p0) {
            Intrinsics.checkNotNullParameter(p0, "");
            return new AFc1oSDK(new LinkedHashMap(), p0, null);
        }
    }

    public final void AFInAppEventType(String p0, Object p1) {
        Intrinsics.checkNotNullParameter(p0, "");
        this.AFKeystoreWrapper.put(p0, p1);
        AFc1kSDK aFc1kSDK = this.values;
        if (aFc1kSDK != null) {
            aFc1kSDK.valueOf(this.AFKeystoreWrapper);
        }
    }

    public final boolean AFInAppEventParameterName(String p0) {
        Intrinsics.checkNotNullParameter(p0, "");
        return this.AFKeystoreWrapper.containsKey(p0);
    }
}
