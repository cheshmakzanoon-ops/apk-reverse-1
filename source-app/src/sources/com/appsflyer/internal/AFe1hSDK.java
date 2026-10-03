package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\u0006\u0010\u0002\u001a\u00020\t\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\t\u0012\b\b\u0002\u0010\u0014\u001a\u00020\f¢\u0006\u0004\b\u0015\u0010\u0016J\u001a\u0010\u0004\u001a\u00020\u00032\b\u0010\u0002\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u0010\u0010\u0007\u001a\u00020\u0006HÖ\u0001¢\u0006\u0004\b\u0007\u0010\bJ\u0010\u0010\n\u001a\u00020\tH×\u0001¢\u0006\u0004\b\n\u0010\u000bR\u0011\u0010\u000f\u001a\u00020\fX\u0007¢\u0006\u0006\n\u0004\b\r\u0010\u000eR\u0011\u0010\r\u001a\u00020\tX\u0007¢\u0006\u0006\n\u0004\b\u0010\u0010\u0011R\u0013\u0010\u0012\u001a\u0004\u0018\u00010\tX\u0007¢\u0006\u0006\n\u0004\b\u0012\u0010\u0011"}, d2 = {"Lcom/appsflyer/internal/AFe1hSDK;", "", "p0", "", "equals", "(Ljava/lang/Object;)Z", "", "hashCode", "()I", "", "toString", "()Ljava/lang/String;", "Lcom/appsflyer/internal/AFe1iSDK;", "AFInAppEventType", "Lcom/appsflyer/internal/AFe1iSDK;", "values", "AFInAppEventParameterName", "Ljava/lang/String;", "valueOf", "p1", "p2", "<init>", "(Ljava/lang/String;Ljava/lang/String;Lcom/appsflyer/internal/AFe1iSDK;)V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AFe1hSDK {

    public final String AFInAppEventType;

    public final AFe1iSDK values;
    public final String valueOf;

    public final boolean equals(Object p0) {
        if (this == p0) {
            return true;
        }
        if (!(p0 instanceof AFe1hSDK)) {
            return false;
        }
        AFe1hSDK aFe1hSDK = (AFe1hSDK) p0;
        return Intrinsics.areEqual(this.AFInAppEventType, aFe1hSDK.AFInAppEventType) && Intrinsics.areEqual(this.valueOf, aFe1hSDK.valueOf) && this.values == aFe1hSDK.values;
    }

    public final int hashCode() {
        int iHashCode = this.AFInAppEventType.hashCode() * 31;
        String str = this.valueOf;
        return ((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.values.hashCode();
    }

    public final String toString() {
        StringBuilder sb = new StringBuilder("AFe1hSDK(AFInAppEventType=");
        sb.append(this.AFInAppEventType);
        sb.append(", valueOf=");
        sb.append(this.valueOf);
        sb.append(", values=");
        sb.append(this.values);
        sb.append(')');
        return sb.toString();
    }

    public AFe1hSDK(String str, String str2, AFe1iSDK aFe1iSDK) {
        Intrinsics.checkNotNullParameter(str, "");
        Intrinsics.checkNotNullParameter(aFe1iSDK, "");
        this.AFInAppEventType = str;
        this.valueOf = str2;
        this.values = aFe1iSDK;
    }
}
