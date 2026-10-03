package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFh1nSDK {
    public final String AFInAppEventParameterName;
    public final AFh1mSDK AFInAppEventType;
    private final boolean AFKeystoreWrapper;
    public final AFh1pSDK valueOf;
    public final String values;

    public AFh1nSDK(String str) throws JSONException {
        AFh1pSDK aFh1pSDK;
        if (str == null) {
            throw new JSONException("Failed to parse remote configuration JSON: originalJson is null");
        }
        try {
            JSONObject jSONObject = new JSONObject(str);
            String string = jSONObject.getString("ver");
            this.values = string;
            this.AFKeystoreWrapper = jSONObject.optBoolean("test_mode");
            this.AFInAppEventParameterName = str;
            if (string.startsWith("default")) {
                aFh1pSDK = AFh1pSDK.DEFAULT;
            } else {
                aFh1pSDK = AFh1pSDK.CUSTOM;
            }
            this.valueOf = aFh1pSDK;
            JSONObject jSONObjectOptJSONObject = jSONObject.optJSONObject("features");
            this.AFInAppEventType = jSONObjectOptJSONObject != null ? new AFh1mSDK(jSONObjectOptJSONObject) : null;
        } catch (JSONException e) {
            AFLogger.afErrorLogForExcManagerOnly("Error in RC config parsing", e);
            throw new JSONException("Failed to parse remote configuration JSON");
        }
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        AFh1nSDK aFh1nSDK = (AFh1nSDK) obj;
        if (this.AFKeystoreWrapper == aFh1nSDK.AFKeystoreWrapper && this.values.equals(aFh1nSDK.values)) {
            return this.AFInAppEventParameterName.equals(aFh1nSDK.AFInAppEventParameterName);
        }
        return false;
    }

    public final int hashCode() {
        int iHashCode = ((((this.AFKeystoreWrapper ? 1 : 0) * 31) + this.values.hashCode()) * 31) + this.AFInAppEventParameterName.hashCode();
        AFh1mSDK aFh1mSDK = this.AFInAppEventType;
        return aFh1mSDK != null ? (iHashCode * 31) + aFh1mSDK.hashCode() : iHashCode;
    }
}
