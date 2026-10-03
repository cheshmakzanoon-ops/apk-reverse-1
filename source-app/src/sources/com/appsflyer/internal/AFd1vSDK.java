package com.appsflyer.internal;

import android.content.Context;
import kotlin.jvm.internal.Intrinsics;

public interface AFd1vSDK {
    AFa1ySDK AFInAppEventParameterName(Context context);

    public static final class AFa1ySDK {
        public final String AFKeystoreWrapper;
        public final float values;

        public final boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (!(obj instanceof AFa1ySDK)) {
                return false;
            }
            AFa1ySDK aFa1ySDK = (AFa1ySDK) obj;
            return Intrinsics.areEqual(Float.valueOf(this.values), Float.valueOf(aFa1ySDK.values)) && Intrinsics.areEqual(this.AFKeystoreWrapper, aFa1ySDK.AFKeystoreWrapper);
        }

        public final int hashCode() {
            int iFloatToIntBits = Float.floatToIntBits(this.values) * 31;
            String str = this.AFKeystoreWrapper;
            return iFloatToIntBits + (str == null ? 0 : str.hashCode());
        }

        public final String toString() {
            StringBuilder sb = new StringBuilder("BatteryData(level=");
            sb.append(this.values);
            sb.append(", charging=");
            sb.append(this.AFKeystoreWrapper);
            sb.append(')');
            return sb.toString();
        }

        public AFa1ySDK(float f, String str) {
            this.values = f;
            this.AFKeystoreWrapper = str;
        }
    }
}
