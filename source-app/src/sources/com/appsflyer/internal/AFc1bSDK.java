package com.appsflyer.internal;

import java.util.HashMap;
import java.util.Map;

public final class AFc1bSDK {
    public final Map<String, Object> values = new HashMap();
    public Map<String, Object> AFKeystoreWrapper = new HashMap();

    public final void values(Map<String, Object> map) {
        if (!this.values.isEmpty()) {
            map.put("partner_data", this.values);
        }
        if (this.AFKeystoreWrapper.isEmpty()) {
            return;
        }
        AFb1vSDK.AFInAppEventType(map).put("partner_data", this.AFKeystoreWrapper);
        this.AFKeystoreWrapper = new HashMap();
    }
}
