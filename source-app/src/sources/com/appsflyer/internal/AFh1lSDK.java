package com.appsflyer.internal;

import org.json.JSONException;
import org.json.JSONObject;

public final class AFh1lSDK {
    public final int AFInAppEventType;
    public final long AFKeystoreWrapper;
    public final int valueOf;
    public final String values;

    public AFh1lSDK(String str, int i, int i2, long j) {
        this.values = str;
        this.valueOf = i;
        this.AFInAppEventType = i2;
        this.AFKeystoreWrapper = j;
    }

    public final String AFInAppEventType() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("sdk_ver", this.values);
            jSONObject.put("min", this.valueOf);
            jSONObject.put("expire", this.AFInAppEventType);
            jSONObject.put("ttl", this.AFKeystoreWrapper);
        } catch (JSONException unused) {
        }
        return jSONObject.toString();
    }

    public final int hashCode() {
        String str = this.values;
        return ((((((str != null ? str.hashCode() : 0) * 31) + this.valueOf) * 31) + this.AFInAppEventType) * 31) + ((int) this.AFKeystoreWrapper);
    }

    public final boolean equals(Object obj) {
        String str;
        if (this == obj) {
            return true;
        }
        if (obj != null && getClass() == obj.getClass()) {
            AFh1lSDK aFh1lSDK = (AFh1lSDK) obj;
            if (this.valueOf == aFh1lSDK.valueOf && this.AFInAppEventType == aFh1lSDK.AFInAppEventType && this.AFKeystoreWrapper == aFh1lSDK.AFKeystoreWrapper && (str = this.values) != null && str.equals(aFh1lSDK.values)) {
                return true;
            }
        }
        return false;
    }
}
