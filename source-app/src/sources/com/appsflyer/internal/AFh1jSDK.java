package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.List;
import java.util.concurrent.TimeUnit;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\t\b\u0000\u0018\u00002\u00020\u0001BC\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0018\u0012\b\b\u0002\u0010\u001b\u001a\u00020\u0012\u0012\u000e\b\u0002\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\f0\u0015\u0012\u0006\u0010\u001d\u001a\u00020\u0006\u0012\u0006\u0010\u001e\u001a\u00020\f\u0012\u0006\u0010\u001f\u001a\u00020\f¢\u0006\u0004\b \u0010!J\u001a\u0010\u0004\u001a\u00020\u00032\b\u0010\u0002\u001a\u0004\u0018\u00010\u0001H\u0096\u0002¢\u0006\u0004\b\u0004\u0010\u0005J\u000f\u0010\u0007\u001a\u00020\u0006H\u0016¢\u0006\u0004\b\u0007\u0010\bR\u0011\u0010\u000b\u001a\u00020\u00038G¢\u0006\u0006\u001a\u0004\b\t\u0010\nR\u0011\u0010\t\u001a\u00020\fX\u0007¢\u0006\u0006\n\u0004\b\r\u0010\u000eR\u0011\u0010\u0011\u001a\u00020\u0006X\u0007¢\u0006\u0006\n\u0004\b\u000f\u0010\u0010R\u0011\u0010\u000f\u001a\u00020\u0012X\u0007¢\u0006\u0006\n\u0004\b\t\u0010\u0013R\u0011\u0010\r\u001a\u00020\fX\u0007¢\u0006\u0006\n\u0004\b\u0014\u0010\u000eR\u0017\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\f0\u0015X\u0007¢\u0006\u0006\n\u0004\b\u000b\u0010\u0016R\u0011\u0010\u001a\u001a\u00020\u0018X\u0007¢\u0006\u0006\n\u0004\b\u0011\u0010\u0019"}, d2 = {"Lcom/appsflyer/internal/AFh1jSDK;", "", "p0", "", "equals", "(Ljava/lang/Object;)Z", "", "hashCode", "()I", "AFInAppEventParameterName", "()Z", "valueOf", "", "AFInAppEventType", "Ljava/lang/String;", "AFKeystoreWrapper", "I", "values", "", "F", "AFLogger", "", "Ljava/util/List;", "registerClient", "", "J", "unregisterClient", "p1", "p2", "p3", "p4", "p5", "<init>", "(JFLjava/util/List;ILjava/lang/String;Ljava/lang/String;)V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFh1jSDK {

    public final float AFKeystoreWrapper;

    public final String AFInAppEventParameterName;

    public final int values;

    public final String AFInAppEventType;

    public List<String> registerClient;

    public long unregisterClient;

    public AFh1jSDK(long j, float f, List<String> list, int i, String str, String str2) {
        Intrinsics.checkNotNullParameter(list, "");
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(str2, "");
        this.unregisterClient = j;
        this.AFKeystoreWrapper = f;
        this.registerClient = list;
        this.values = i;
        this.AFInAppEventParameterName = str;
        this.AFInAppEventType = str2;
    }

    public final boolean AFInAppEventParameterName() {
        return TimeUnit.SECONDS.toMillis(this.unregisterClient) > AFb1vSDK.valueOf().AFInAppEventType().mo783d().AFKeystoreWrapper();
    }

    public final boolean equals(Object p0) {
        if (this == p0) {
            return true;
        }
        if (!Intrinsics.areEqual(getClass(), p0 != null ? p0.getClass() : null)) {
            return false;
        }
        if (p0 != null) {
            AFh1jSDK aFh1jSDK = (AFh1jSDK) p0;
            return this.unregisterClient == aFh1jSDK.unregisterClient && this.AFKeystoreWrapper == aFh1jSDK.AFKeystoreWrapper && Intrinsics.areEqual(this.registerClient, aFh1jSDK.registerClient) && this.values == aFh1jSDK.values && Intrinsics.areEqual(this.AFInAppEventParameterName, aFh1jSDK.AFInAppEventParameterName) && Intrinsics.areEqual(this.AFInAppEventType, aFh1jSDK.AFInAppEventType);
        }
        throw new NullPointerException("null cannot be cast to non-null type com.appsflyer.internal.model.rc.RDConfiguration");
    }

    public final int hashCode() {
        return (((((((((UByte$.ExternalSyntheticBackport0.m(this.unregisterClient) * 31) + Float.floatToIntBits(this.AFKeystoreWrapper)) * 31) + this.registerClient.hashCode()) * 31) + this.values) * 31) + this.AFInAppEventParameterName.hashCode()) * 31) + this.AFInAppEventType.hashCode();
    }
}
