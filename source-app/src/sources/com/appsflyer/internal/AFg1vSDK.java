package com.appsflyer.internal;

import kotlin.jvm.internal.Intrinsics;

public final class AFg1vSDK {
    final int AFInAppEventParameterName;
    final int AFInAppEventType;
    final int AFKeystoreWrapper;
    final String valueOf;
    final int values;

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof AFg1vSDK)) {
            return false;
        }
        AFg1vSDK aFg1vSDK = (AFg1vSDK) obj;
        return this.AFKeystoreWrapper == aFg1vSDK.AFKeystoreWrapper && this.AFInAppEventParameterName == aFg1vSDK.AFInAppEventParameterName && this.AFInAppEventType == aFg1vSDK.AFInAppEventType && this.values == aFg1vSDK.values && Intrinsics.areEqual(this.valueOf, aFg1vSDK.valueOf);
    }

    public final int hashCode() {
        return (((((((this.AFKeystoreWrapper * 31) + this.AFInAppEventParameterName) * 31) + this.AFInAppEventType) * 31) + this.values) * 31) + this.valueOf.hashCode();
    }

    public final String toString() {
        StringBuilder sb = new StringBuilder("CmpTcfData(policyVersion=");
        sb.append(this.AFKeystoreWrapper);
        sb.append(", gdprApplies=");
        sb.append(this.AFInAppEventParameterName);
        sb.append(", cmpSdkId=");
        sb.append(this.AFInAppEventType);
        sb.append(", cmpSdkVersion=");
        sb.append(this.values);
        sb.append(", tcString=");
        sb.append(this.valueOf);
        sb.append(')');
        return sb.toString();
    }

    public AFg1vSDK(int i, int i2, int i3, int i4, String str) {
        Intrinsics.checkNotNullParameter(str, "");
        this.AFKeystoreWrapper = i;
        this.AFInAppEventParameterName = i2;
        this.AFInAppEventType = i3;
        this.values = i4;
        this.valueOf = str;
    }
}
