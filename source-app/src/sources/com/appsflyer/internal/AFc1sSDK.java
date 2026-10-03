package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import org.json.JSONObject;

public final class AFc1sSDK {
    static JSONObject AFInAppEventType(String str) {
        JSONObject jSONObjectValues = AFa1oSDK.values(str);
        if (jSONObjectValues != null) {
            try {
                if (jSONObjectValues.has("ol_id")) {
                    String strOptString = jSONObjectValues.optString("ol_scheme", null);
                    String strOptString2 = jSONObjectValues.optString("ol_domain", null);
                    String strOptString3 = jSONObjectValues.optString("ol_ver", null);
                    if (strOptString != null) {
                        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.ONELINK_SCHEME, strOptString);
                    }
                    if (strOptString2 != null) {
                        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.ONELINK_DOMAIN, strOptString2);
                    }
                    if (strOptString3 != null) {
                        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.ONELINK_VERSION, strOptString3);
                    }
                }
            } catch (Throwable th) {
                StringBuilder sb = new StringBuilder("Error in handleResponse: ");
                sb.append(th.getMessage());
                AFLogger.afErrorLogForExcManagerOnly(sb.toString(), th);
                AFb1vSDK.valueOf().AFInAppEventType().afInfoLog().AFKeystoreWrapper();
                AFb1vSDK.valueOf().AFInAppEventType().afInfoLog().valueOf();
            }
        }
        return jSONObjectValues;
    }
}
